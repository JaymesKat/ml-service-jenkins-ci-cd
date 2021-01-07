[![JaymesKat](https://circleci.com/gh/JaymesKat/ml-microservice-kubernetes.svg?style=svg)](https://app.circleci.com/pipelines/github/JaymesKat/ml-microservice-kubernetes)

## Application Overview

This API, built with Flask, provides access to a pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing). This API serves out predictions (inference) about housing prices through API calls. This app could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.

## Setup the Environment

- Create a virtualenv and activate it
- Run `make install` to install the necessary dependencies

### Running `app.py`

1. Standalone: `python app.py`
2. Run in Docker: `./run_docker.sh`
3. Run in Kubernetes: `./run_kubernetes.sh`
4. To upload the docker image to your Docker hub by running the script `upload_docker.sh`
5. Create a directory `.circleci` and create a configuration file `config.yml` inside of it to integrate CircleCI

### Making a House Price Prediction

- Run Docker or kubernetes shell scripts on another terminal: `make_predictions.sh` to make a prediction
- Examples of log output can be found in the `docker_out.txt` file

### Steps to Run App in a Kubernetes Cluster

- Setup and Configure [Docker](https://docs.docker.com/get-docker/) locally (You need to have a docker account)
- Setup and Configure [Kubernetes(Minikube)](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- Create Flask app in Container
- Run via kubectl
