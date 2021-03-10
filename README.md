[![JaymesKat](https://circleci.com/gh/JaymesKat/ml-microservice-kubernetes.svg?style=svg)](https://app.circleci.com/pipelines/github/JaymesKat/ml-microservice-kubernetes)

## Application Overview

This API, built with Flask, provides access to a pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing). This API serves out predictions (inference) about housing prices through API calls. This app could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.

## Project Details

- Build app into Docker image and run within container
- Perform linting before building Docker image
- Upload image to AWS Docker Container Registry ([ECR](https://aws.amazon.com/ecr/))
- Set up Kubernetes Cluster using Cloudformation.
- Set up CI/CD Pipeline with Jenkins and enable multi-branch builds
- Enable blue-green deployment of application to Kubernetes Cluster

## Setup the Local Environment

- Create a virtualenv and activate it
- Run `make install` to install the necessary dependencies

## Setting up Jenkins Server

Deploy Jenkins within an EC2 instance running Ubuntu 18.04. [Guide](https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04)
SSH into server and ensure you have installed the following:

- git
- Docker
- kubectl
- aws cli
- hadolint
- jq
- curl
- python3
- pip

Configure AWS CLI with secret key credentials. Ensure that the user attached to the credentials has necessary rights to create and manage kubernetes clusters on AWS

## Creating Kubernetes Cluster on AWS

1. Create VPC in which the Cluster will be created by running command below in your terminal

```
aws cloudformation create-stack --stack-name eks-cluster-vpc --template-body file://cloudformation/network.yaml
```

2. Create an IAM role with the following IAM policies: `AmazonEKSClusterPolicy`, `AmazonEKSServicePolicy`

3. Launch Cluster in VPC by running command below

```
./scripts/create_cluster.sh <region> <cluster_iam_role> <subnet_ids> <security_group>

```

where `<region>` is the region you want to create the cluster in, `<iam_role>` is the ARN for IAM role created in the previous step, `<subnet_ids>` are the ids for the VPC created in step 1, `<security_group>` is the id for the security group created in step 1. These can be seen in the Outputs section of AWS Cloudformation dashboard for the stack created in Step 1

4. Confirm that the cluster

```
aws eks --region <region> update-kubeconfig --name ml-cluster
kubectl get svc
```

where `<region>` is the region used to create the cluster.
The output should show a ClusterIP running

5. Launch Nodegroup into Cluster (The cluster created in the last step does not create nodes. These are created separated and added to the cluster)
   Fill the correct parameter values in this file `cloudformation/nodegroup-params.json` before running the command below:

   ```
    ./create_nodegroup.sh cloudformation/nodegroup.yaml cloudformation/nodegroup-params.json
   ```

6. Configure nodes to communicate with cluster. Replace the `rolelearn` key in `cloudformation/aws-auth.yaml` with the IAM outputted in Cloudformation after stack in Step 5 is completed

```
kubectl apply -f cloudformation/aws-auth.yaml
```

7. Check that the nodes are running within cluster

```
kubectl get nodes --watch
```

8. Now that you have the cluster running, we will look at deploying the application to the cluster with Zero downtime using blue-green strategy

9. Create an AWS ECR registry using your AWS account where the docker images will be stored

## Set up CI/CD pipeline in Jenkins

Note: This project uses AWS ECR. You will need to update this file `scripts/build_upload_docker.sh` with the correct values for these variables. `ecr_host`, `region` based on what the container registry created in the previous section

The following steps are included in the Jenkins pipeline defined in the `Jenkins` file

- Setup: Creates environment by installing application dependencies
- Linting: Checks project and Dockerfile for errors
- Build: Builds and uploads Docker Image to AWS ECR
- Update Kubeconfig: This step ensures that we can communicate with cluster using the kubectl utility. (Use appropriate region where the cluster is running)
- Deploy blue environmnent
- Deploy green environment
  The last two steps run based on which git branch is deployed i.e. blue or green
