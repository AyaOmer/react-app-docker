# Use the official Node.js image as the base image for the builder stage
FROM node:14-alpine as builder

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React.js app
RUN npm run build

# Use a lightweight nginx image for the runtime stage
FROM nginx:alpine

# Copy the built app from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the port that Nginx will listen on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
