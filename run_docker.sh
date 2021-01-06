#!/usr/bin/env bash

## Complete the following steps to get Docker running locally
# Build image and add a descriptive tag
docker build --tag=jpkat/ml-microservice . 

# List docker images
docker images

# Run flask app
docker run -i -p 8000:80 -t jpkat/ml-microservice
