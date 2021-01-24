pipeline {
    agent { docker { image 'python:3.7.3-stretch' } }
    stages {
        stage ('Setup environment and dependencies') {
            steps {
                sh '#!/bin/bash'
                sh 'make setup'
                sh 'make install'
            }
        }
        stage('Lint') {
            steps {
                sh 'wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64'
                sh 'chmod +x /bin/hadolint'
                sh 'make lint'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh './run_docker.sh'
            }
        }
    }
}