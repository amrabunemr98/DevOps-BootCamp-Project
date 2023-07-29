pipeline {
     agent any
     environment {
        docker_file_app = 'DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/FlaskApp/Dockerfile'
        docker_file_db = 'DevOps-BootCamp-Project/Jenkinsfile/MySQL-and-Python/MySQL_Queries/Dockerfile'
        ecr_repository = '817775426354.dkr.ecr.us-east-1.amazonaws.com/sprints-ecr-repo'
     }
     stages{
        stage('Build Docker image for app.py and push it to ECR') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')])
                script {
                    def imageTag = "build-${env.BUILD_NUMBER}"
                    def imageName = "${ecr_repository}:${imageTag}"
                    sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 705434271522.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t ${imageName} -f ${docker_file_app} .
                    docker tag ${imageName} ${ecr_repository}:${imageTag}
                    docker push ${ecr_repository}:${imageTag}
                    docker rmi ${ecr_repository}:${imageTag}
                    '''
                }
            }
        }
        stage('Build Docker image mysql and push it to ECR') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')])
                script {
                    def imageTag = "build-${env.BUILD_NUMBER}"
                    def imageName = "${ecr_repository}:${imageTag}"
                    sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 705434271522.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t ${imageName} -f ${docker_file_db} .
                    docker tag ${imageName} ${ecr_repository}:${imageTag}
                    docker push ${ecr_repository}:${imageTag}
                    docker rmi ${ecr_repository}:${imageTag}
                    '''
                }
            }
        }
    }


}
