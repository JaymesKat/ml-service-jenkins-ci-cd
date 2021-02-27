pipeline {
    agent any
    stages {
        stage ('Setup environment and dependencies') {
            steps {
                sh '''
                #!/bin/bash
                chmod +x -R ${env.WORKSPACE}
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