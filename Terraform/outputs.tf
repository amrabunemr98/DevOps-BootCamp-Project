# Define an output variable for the public IP of the Jenkins EC2 instance
output "Public-ip-jenkins" {
  value = aws_instance.ec2.public_ip   # Output the public IP of the EC2 instance
}

# Define an output variable for the ECR repository URL
output "ecr-url" {
  value = aws_ecr_repository.sprints_ecr.repository_url   # Output the repository URL
}




