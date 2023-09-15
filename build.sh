#!/bin/bash

# Define the Dockerfile name
dockerfile_name="Dockerfile_3_10_alpine"
#dockerfile_name="Dockerfile_3_10_slim_bullseye"

# Define the platform argument
#platform_arg="--platform linux/amd64,linux/arm64,linux/arm/v7"
platform_arg=""

image_name="prikid/docker_python_scrapy_selenium_geckodriver"
current_date=$(date +"%d%m%Y")
# extract the tag part
tag_part=${dockerfile_name#Dockerfile_}

# Build and push the Docker image
docker buildx build $platform_arg \
  -f "$dockerfile_name" \
  -t "$image_name:$tag_part-$current_date" \
  -t "$image_name:$tag_part-latest" \
  --push .