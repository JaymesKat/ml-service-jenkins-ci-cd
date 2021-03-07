#!/bin/bash
EXTERNAL_IP=$(kubectl get svc ml-service -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
$ curl -s http://$EXTERNAL_IP/ | grep Sklearn