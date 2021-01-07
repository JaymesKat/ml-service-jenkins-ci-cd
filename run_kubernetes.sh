#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=jpkat/ml-microservice

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run ml-service --image=jpkat/ml-microservice:latest --port=80

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl port-forward ml-service 8000:80
