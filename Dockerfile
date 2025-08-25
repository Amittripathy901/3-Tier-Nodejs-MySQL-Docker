# Stage 1: Build the client application
FROM node:20-alpine AS client-builder
WORKDIR /usr/src/app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# Stage 2: Build the server and serve the client
FROM node:20-alpine AS server-runner
WORKDIR /usr/src/app/server
COPY server/package*.json ./
RUN npm install --omit=dev
COPY server/ ./

# Copy the built client files from the 'client-builder' stage
COPY --from=client-builder /usr/src/app/client/dist ./public/

# Expose the port the server will run on
EXPOSE 5000

# Command to run the server
CMD ["npm", "start"]
