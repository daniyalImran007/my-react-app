# === STAGE 1: Build ===
FROM node:20-alpine AS builder

WORKDIR /app

# Copy lockfile first (for caching)
COPY package.json package-lock.json ./

# Install deps
RUN npm ci

# Copy source
COPY . .

# Build React app
RUN npm run build

# === STAGE 2: Runtime (optional, for self-hosting) ===
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "node_modules/.bin/serve", "-s", "build"]