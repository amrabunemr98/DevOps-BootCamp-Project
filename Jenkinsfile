pipeline {
    agent any
    environment {
        docker_file_app = 'DevOps-BootCamp-Project/MySQL-and-Python/FlaskApp/Dockerfile'
        docker_file_db = 'DevOps-BootCamp-Project/MySQL-and-Python/MySQL_Queries/Dockerfile'
        ecr_repository = '817775426354.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr-repo'
        imageTag = "build-${env.BUILD_NUMBER}"
        imageName = "${ecr_repository}:${imageTag}"
    }
    stages {
        stage('Build Docker image for app.py and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir("DevOps-BootCamp-Project/MySQL-and-Python/FlaskApp"){
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                        sh "docker build -t ${imageName} -f Dockerfile ."
                        sh "docker tag ${imageName} ${ecr_repository}:${imageTag}"
                        sh "docker push ${ecr_repository}:${imageTag}"
                        sh "docker rmi ${ecr_repository}:${imageTag}"
                    }
                }
            }
        }
        stage('Build Docker image mysql and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir("DevOps-BootCamp-Project/MySQL-and-Python/MySQL_Queries") {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                        sh "docker build -t ${imageName} -f Dockerfile ."
                        sh "docker tag ${imageName} ${ecr_repository}:${imageTag}"
                        sh "docker push ${ecr_repository}:${imageTag}"
                        sh "docker rmi ${ecr_repository}:${imageTag}"
                    }
                }
            }
        }
    }
}



