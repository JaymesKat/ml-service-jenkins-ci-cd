pipeline {
    agent any
    stages {
        stage ('Setup environment and dependencies') {
            steps {
                sh '''
                #!/bin/bash
                chmod +x -R ${WORKSPACE}
                make setup
                make install
                curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
                chmod +x ./kubectl
                '''
            }
        }
        stage('Lint') {
            steps {
                sh '''
                #!/bin/bash
                make activate_env
                make lint
                '''
            }
        }
        stage('Push Docker Image') {
            steps {
                withAWS(region:'us-west-1', credentials: 'aws_credentials') {
                    sh 'cd scripts'
                    sh './scripts/build_upload_docker.sh'
                }
            }
        }
        stage('Update kubeconfig') {
            steps {
                withAWS(region:'us-west-1', credentials: 'aws_credentials') {
                    sh 'aws eks --region us-west-1 update-kubeconfig --name ml-cluster'
                    sh './kubectl apply -f k8s/service.yaml'
                }
            }
        }
        stage('Deploy Blue environment') {
            when { branch 'blue'}
            steps {
                withAWS(region:'us-west-1', credentials: 'aws_credentials') {
                    sh './kubectl apply -f k8s/blue/deployment.yaml'
                    sh './kubectl get deployments'
                    sh './kubectl get pods'
                    sh './k8s/blue-green-deploy.sh ml-deployment-blue ml-service blue'
                    sh './kubectl get deployments'
                    sh './kubectl get pods'
                }
            }
        }
        stage('Deploy Green environment') {
            when { branch 'green'}
            steps {
                withAWS(region:'us-west-1', credentials: 'aws_credentials') {
                    sh './kubectl apply -f k8s/green/deployment.yaml'
                    sh './kubectl get deployments'
                    sh './kubectl get pods'
                    sh './k8s/blue-green-deploy.sh ml-deployment-green ml-service green'
                    sh './kubectl get deployments'
                    sh './kubectl get pods'
                    sh '''
                        HOST=$(./kubectl get svc ml-service -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")
                        curl -s http://$HOST:8000 | grep sklearn
                        '''
                }
            }
        }
    }
}