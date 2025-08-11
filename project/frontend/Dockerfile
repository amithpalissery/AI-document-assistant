# Stage 1: Build the frontend
FROM node:18 AS build

# Set working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Set executable permissions on the vite binary
RUN chmod +x ./node_modules/.bin/vite

# Build the application for production
RUN /app/node_modules/.bin/vite build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the built application from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80
