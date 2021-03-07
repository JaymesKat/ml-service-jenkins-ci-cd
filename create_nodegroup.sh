#!/bin/bash
aws cloudformation create-stack --stack-name ml-service-nodegroup --template-body file://$1 --parameters file://$2 --capabilities CAPABILITY_NAMED_IAM