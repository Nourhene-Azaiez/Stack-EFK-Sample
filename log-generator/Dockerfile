# Use an official Ubuntu base image
FROM ubuntu:latest

# Install Bash and any necessary tools
RUN apt-get update && apt-get install -y \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the log generator script into the container
COPY log-generator/log-generator.sh /app/log-generator.sh

# Make the script executable
RUN chmod +x /app/log-generator.sh

# Set the default command to run the script
ENTRYPOINT ["/bin/bash", "/app/log-generator.sh"]
