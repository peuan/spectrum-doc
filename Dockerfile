# Base image with Node.js (small Alpine version)
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Step 1: Install dependencies only when package.json changes
FROM base AS builder
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Step 2: Copy source code and build the site
COPY . .
RUN yarn build

# Step 3: Use a lightweight web server to serve the static site
FROM nginx:alpine AS runner
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
