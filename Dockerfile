# Stage 1: Build Stage
FROM node:22 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies (including devDependencies)
RUN npm install --ignore-scripts

# Copy the rest of the application code
COPY . .

# Build the TypeScript application
RUN npm run build

# Remove development dependencies
RUN npm prune --production

# Stage 2: Production Stage
FROM node:22

# Set working directory
WORKDIR /app

# Copy package.json to the container
COPY package*.json ./

# Copy the production node_modules from the build stage
COPY --from=build /app/node_modules ./node_modules

# Copy the built application from the build stage
COPY --from=build /app/dist ./dist

#Expose the aplication port
EXPOSE 4120

# Start the application
CMD ["node", "dist/index.js"]


