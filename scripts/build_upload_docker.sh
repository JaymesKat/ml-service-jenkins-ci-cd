#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# ECR host
ecr_host=417548009410.dkr.ecr.us-west-1.amazonaws.com
region=us-west-1
# Step 1:
# Create docker image
docker_image=ml-microservice
docker build --tag="$docker_image" . 

# Step 2:  
# Authenticate with Amazon ECR
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$ecr_host"

# Step 3:
# Tag and push image to a ECR repository
docker tag  "$docker_image:latest" "$ecr_host/$docker_image:latest"
docker push "$ecr_host/$docker_image:latest" 