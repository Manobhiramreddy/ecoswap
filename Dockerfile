# Stage 1: build the frontend
FROM node:18-alpine AS build
WORKDIR /app

# Copy only frontend files
COPY whole-frontend/package*.json ./
RUN npm install --silent

# Copy the rest of the frontend source code
COPY whole-frontend ./

# Build the Vite app
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
