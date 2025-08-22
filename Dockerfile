# Stage 1: Build React + Vite App
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Minimal runtime image
FROM node:18-alpine

WORKDIR /app

# Install "serve" to serve static files
RUN npm install -g serve

# Copy production build
COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
