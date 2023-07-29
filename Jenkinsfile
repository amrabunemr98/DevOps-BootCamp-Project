pipeline {
    agent any
    environment {
        docker_file_app = 'MySQL-and-Python/FlaskApp/Dockerfile'
        docker_file_db = 'MySQL-and-Python/MySQL_Queries/Dockerfile'
        ecr_repository = '817775426354.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr-repo'
        imageTagApp = "build-${BUILD_NUMBER}-app"
        imageNameapp = "${ecr_repository}:${imageTagApp}"
        imageTagDb = "build-${BUILD_NUMBER}-db"
        imageNameDB = "${ecr_repository}:${imageTagDb}"
    }
    stages {
        stage('Build Docker image for app.py and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                    sh "docker build -t ${imageNameapp} -f ${docker_file_app} ."
                    sh "docker tag ${imageNameapp} ${ecr_repository}:${imageTagApp}"
                    sh "docker push ${ecr_repository}:${imageTagApp}"
                    sh "docker rmi ${ecr_repository}:${imageTagApp}"
                }
                    
            }
        }
        stage('Build Docker image mysql and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                    sh "docker build -t ${imageNameDB} -f ${docker_file_db} ."
                    sh "docker tag ${imageNameDB} ${ecr_repository}:${imageTagDb}"
                    sh "docker push ${ecr_repository}:${imageTagDb}"
                    sh "docker rmi ${ecr_repository}:${imageTagDb}"
                }
            }
        }
    }
}




