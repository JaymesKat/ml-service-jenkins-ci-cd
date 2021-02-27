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
                sh './build_upload_docker.sh'
            }
        }
        stage('Update kubeconfig') {
            steps {
                sh 'aws eks --region us-west-1 update-kubeconfig --name ml-cluster'
                sh 'aws eks --region us-west-1 describe-cluster --name ml-cluster --query cluster.status'
            }
        }
    }
}