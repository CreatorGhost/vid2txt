#!/bin/bash

# Define Docker image name and tag
DOCKER_IMAGE_NAME="whisper-transcription"
DOCKER_IMAGE_TAG="latest"

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_video_file> <path_to_output_text_file>"
    exit 1
fi

# Resolve absolute paths on the host
VIDEO_PATH_ON_HOST=$(realpath "$1")
OUTPUT_PATH_ON_HOST=$(realpath "$2")

# Check if the Docker image exists, build if not
image_exists=$(docker images -q ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG})
if [ -z "$image_exists" ]; then
    echo "Docker image not found: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}. Building now..."
    docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .
    if [ $? -ne 0 ]; then
        echo "Failed to build Docker image. Exiting."
        exit 1
    fi
fi

# Run the Docker container with volume mappings
docker run -v "$VIDEO_PATH_ON_HOST":/video -v "$OUTPUT_PATH_ON_HOST":/output ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} /video /output