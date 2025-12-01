#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e

# Define some environment variables
export IMAGE_NAME="hw3-app-api"
export BASE_DIR=$(pwd)

# Create the network if we don't have it yet
docker network inspect hw3-app-network >/dev/null 2>&1 || docker network create hw3-app-network

# Build the image based on the Dockerfile
docker build -t $IMAGE_NAME -f Dockerfile .

# Run the container
docker run --rm --name $IMAGE_NAME -ti \
-v "$BASE_DIR":/app \
-p 9000:9000 \
-e DEV=1 \
--network hw3-app-network \
$IMAGE_NAME