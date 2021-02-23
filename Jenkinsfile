pipeline {
    agent { docker { image 'python:3.7.3-stretch' } }
    stages {
        stage ('Setup environment and dependencies') {
            steps {
                sh '''
                #!/bin/bash

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
        stage('Build Docker Image') {
            steps {
                sh './build_upload_docker.sh'
            }
        }
    }
}