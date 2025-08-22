# --- Stage 1: Builder ---
FROM node:18-alpine AS builder

WORKDIR /app

# Only copy package files first to optimize caching
COPY package.json package-lock.json ./

# Install dependencies (adds --legacy-peer-deps if required)
RUN npm ci

# Copy the rest of the code
COPY . .

# Run the build (adjust this if your build script is named differently)
RUN npm run build

# --- Stage 2: Production image ---
FROM node:18-alpine AS production

WORKDIR /app

# Install only serve for lightweight serving of static files
RUN npm install -g serve

# Copy built files from builder
COPY --from=builder /app/dist ./dist

# Expose the port the app will run on
EXPOSE 4173

# Command to serve the built app
CMD ["serve", "-s", "dist", "-l", "4173"]
