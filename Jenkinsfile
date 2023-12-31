pipeline {
    agent any
    environment {
        // Define paths and tags for Docker images
        docker_file_app = 'MySQL-and-Python/FlaskApp/Dockerfile'
        docker_file_db = 'MySQL-and-Python/MySQL_Queries/Dockerfile'
        ecr_repository = 'your ECR URL'
        imageTagApp = "build-${BUILD_NUMBER}-app"
        imageNameapp = "${ecr_repository}:${imageTagApp}"
        imageTagDb = "build-${BUILD_NUMBER}-db"
        imageNameDB = "${ecr_repository}:${imageTagDb}"
    }
    stages {
        stage('Build Docker image for app.py and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // Authenticate with AWS ECR to push Docker image
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                    
                    // Build Docker image for app.py
                    sh "docker build -t ${imageNameapp} -f ${docker_file_app} ."
                    
                    // Tag the app Docker image with a version tag
                    sh "docker tag ${imageNameapp} ${ecr_repository}:${imageTagApp}"
                    
                    // Push the app Docker image to ECR
                    sh "docker push ${ecr_repository}:${imageTagApp}"
                    
                    // Remove the locally built app Docker image
                    sh "docker rmi ${ecr_repository}:${imageTagApp}"
                }
            }
        }
        stage('Build Docker image mysql and push it to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // Authenticate with AWS ECR to push Docker image
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecr_repository"
                    
                    // Build Docker image for the MySQL database
                    sh "docker build -t ${imageNameDB} -f ${docker_file_db} ."
                    
                    // Tag the database Docker image with a version tag
                    sh "docker tag ${imageNameDB} ${ecr_repository}:${imageTagDb}"
                    
                    // Push the database Docker image to ECR
                    sh "docker push ${ecr_repository}:${imageTagDb}"
                    
                    // Remove the locally built database Docker image
                    sh "docker rmi ${ecr_repository}:${imageTagDb}"
                }
            }
        }

        stage('Apply Kubernetes files') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // Replace the placeholder with the actual Docker image in the Kubernetes YAML files
                    sh "sed -i \'s|image:.*|image: ${imageNameapp}|g\' Kubernets-files/Deployment_flaskapp.yml"
                    sh "sed -i \'s|image:.*|image: ${imageNameDB}|g\' Kubernets-files/Statefulset_db.yml"
                    
                    sh "aws eks --region us-east-1 update-kubeconfig --name Sprints-EKS-Cluster"

                    // Apply the Kubernetes YAML files
                    sh "kubectl apply -f Kubernets-files/ConfigMap.yml"
                    sh "kubectl apply -f Kubernets-files/Secrets.yml"
                    sh "kubectl apply -f Kubernets-files/Services.yml"
                    sh "kubectl apply -f Kubernets-files/Deployment_flaskapp.yml"
                    sh "kubectl apply -f Kubernets-files/Statefulset_db.yml"
                    sh "kubectl apply -f Kubernets-files/Ingress_NGINX_controller.yml"
                }
                
                
                }
             }
        stage('Retrieve DNS') {
            steps {
                script {
                    // Retrieve the DNS from Kubernetes Service using kubectl
                    def dns = sh(script: 'kubectl get svc flask-app-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"', returnStdout: true).trim()

                    // Display the URL to the website
                    def websiteUrl = "http://${dns}/"
                    echo "Website URL: ${websiteUrl}"
                }
            }
        }
    }
}

















