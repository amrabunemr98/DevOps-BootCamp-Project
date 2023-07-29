pipeline {
    agent any
    environment {
        docker_file_app = 'DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/FlaskApp/Dockerfile'
        docker_file_db = 'DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/MySQL_Queries/Dockerfile'
        ecr_repository = '817775426354.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr-repo'
        imageTag = "build-${env.BUILD_NUMBER}"
        imageName = "${ecr_repository}:${imageTag}"
    }
    stages {
        stage('Build Docker image for app.py and push it to ECR') {
            steps {
                script {
                    def appDockerfilePath = "${env.WORKSPACE}/${docker_file_app}"
                    echo "App Dockerfile Path: ${appDockerfilePath}"
                    dir("DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/FlaskApp"){
                        sh "ls -al" // Print the content of the current directory for debugging purposes
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                        // Specify the build context (current directory) and Dockerfile path within it
                        sh "docker build -t ${imageName} -f ${appDockerfilePath} ."
                        sh "docker tag ${imageName} ${ecr_repository}:${imageTag}"
                        sh "docker push ${ecr_repository}:${imageTag}"
                        sh "docker rmi ${ecr_repository}:${imageTag}"
                    }
                }
            }
        }
        stage('Build Docker image mysql and push it to ECR') {
            steps {
                script {
                    def dbDockerfilePath = "${env.WORKSPACE}/${docker_file_db}"
                    echo "DB Dockerfile Path: ${dbDockerfilePath}"
                    dir("DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/MySQL_Queries") {
                        sh "ls -al" // Print the content of the current directory for debugging purposes
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                        // Specify the build context (current directory) and Dockerfile path within it
                        sh "docker build -t ${imageName} -f ${dbDockerfilePath} ."
                        sh "docker tag ${imageName} ${ecr_repository}:${imageTag}"
                        sh "docker push ${ecr_repository}:${imageTag}"
                        sh "docker rmi ${ecr_repository}:${imageTag}"
                    }
                }
            }
        }
    }
}




