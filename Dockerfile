# Use Node.js (Alpine version for a smaller image)
FROM node:18-alpine AS base

WORKDIR /app

# Step 1: Install dependencies only when package.json changes
FROM base AS builder
COPY package.json package-lock.json ./
RUN npm install --only=production

# Step 2: Copy source code and build the Docusaurus site
COPY . .
RUN npm run build

# Step 3: Use a lightweight web server to serve the static site
FROM nginx:alpine AS runner
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx to serve the site
CMD ["nginx", "-g", "daemon off;"]
