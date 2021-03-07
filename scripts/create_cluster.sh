#!/bin/bash
echo "Creating cluster $2 in region $1"
aws eks --region $1 create-cluster --name ml-cluster \
--role-arn $2 --resources-vpc-config subnetIds=$3,securityGroupIds=$4