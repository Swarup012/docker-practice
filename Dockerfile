# ---------- Stage 1: Build React app ----------
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy rest of the app
COPY . .

# Build React app
RUN npm run build

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:1.25-alpine

# Copy built React files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config (optional, for routing in React apps)
# You can create nginx.conf in your repo and uncomment this line
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Environment variable (for same env in dev & prod)
ENV NODE_ENV=production

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
