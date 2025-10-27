# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /app
# copy package files first for caching
COPY package*.json ./
COPY package-lock.json ./
RUN npm ci --silent

# copy rest and build
COPY . .
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine
# remove default nginx content
RUN rm -rf /usr/share/nginx/html/*
# copy built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# copy a basic nginx config (optional) to support SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
