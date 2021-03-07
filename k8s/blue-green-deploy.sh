#!/bin/bash

# blue-green-deploy.sh <green/deployment>
# Deployment name should be ml-service-blue or ml-service-green

DEPLOYMENTNAME=$1
SERVICE=$2
COLOR=$3

# Wait until the Deployment is ready by checking the MinimumReplicasAvailable condition.
READY=$(kubectl get deployment $DEPLOYMENTNAME -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
while [[ "$READY" != "True" ]]; do
    READY=$(kubectl get deployment $DEPLOYMENTNAME -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
    sleep 6
done

# Update the service selector with the new version
kubectl patch svc $SERVICE -p "{\"spec\":{\"selector\": {\"app\": \"${SERVICE}\", \"name\": \"${COLOR}\"}}}"

echo "Done."