<div align="center">
  <h1 style="color: red;">:man_student: Sprints Graduation Project :man_student:</h1>
</div>

# :computer: Deploying Applications on Kubernetes using CI/CD Pipeline

## :rocket: Introduction:-
- The objective of this project is implementation of an end-to-end Continuous Integration and Continuous Deployment (CI/CD) pipeline for a web application hosted on a Kubernetes cluster. By leveraging tools like Terraform, Ansible, Docker, Jenkins, and Kubernetes, the project showcases the seamless automation of software development, testing, and deployment processes.
![AWS Architecture Diagram (1)](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/b436c955-475d-4a15-94a1-3f9b5f9375f9)
## :hammer_and_wrench: Prerequisites:-
- [x] Github
- [x] Terraform
- [x] AWS
- [x] Docker 
- [x] Ansible
- [x] Kubernetes
- [x] Jenkins
## :gear: Steps to run project:-
1. Clone the Repository:
```
git clone git@github.com:amrabunemr98/DevOps-BootCamp-Project.git
```
2. Run [Bash Script](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/build.sh) :
```
sudo chmod +x build.sh
./build.sh
```
3. Copy ECR URL and Update ECR URL of these files: [Deployment-app](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Kubernets-files/Deployment_flaskapp.yml) [Statefulset-db](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Kubernets-files/Statefulset_db.yml) [Jenkinsfile](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Jenkinsfile)
![Screenshot from 2023-08-06 01-37-48](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/235a22f5-45b8-48e5-9762-5a9d8085eee8)
4. Launch Jenkins Instance to Configure AWS Credentials and Set Up EKS Access:
```
sudo chown -R ubuntu:ubuntu /home/ubuntu/.aws
aws configure
chmod 600 /home/ubuntu/.aws/credentials
aws eks --region us-east-1 update-kubeconfig --name Sprints-EKS-Cluster
```
![WhatsApp Image 2023-08-06 at 2 06 27 AM](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/8d1dea34-857a-4541-8807-863a164241a3)
