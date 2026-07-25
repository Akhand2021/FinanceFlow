FROM node:20-alpine

# Install OpenSSL for Prisma engine compatibility on Alpine Linux
RUN apk add --no-cache openssl

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies
RUN npm install

# Generate Prisma client for linux-musl-openssl-3.0.x
RUN npx prisma generate

# Copy source code
COPY . .

# Build NestJS app
RUN npm run build

# Expose port
EXPOSE 3000

# Start production server
CMD ["npm", "run", "start:prod"]
