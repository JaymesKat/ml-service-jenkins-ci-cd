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
                    sh './build_upload_docker.sh'
                }
            }
        }
        stage('Update kubeconfig') {
            steps {
                withAWS(region:'us-west-1', credentials: 'aws_credentials') {
                    sh 'aws eks --region us-west-1 update-kubeconfig --name ml-cluster'
                    sh 'aws eks --region us-west-1 describe-cluster --name ml-cluster --query cluster.status'
                    sh './kubectl version --client'
                }
            }
        }
    }
}