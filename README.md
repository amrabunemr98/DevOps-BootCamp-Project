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
3. Copy ECR URL from output of bash script and Update ECR URL of these files: [Deployment-app](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Kubernets-files/Deployment_flaskapp.yml) [Statefulset-db](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Kubernets-files/Statefulset_db.yml) [Jenkinsfile](https://github.com/amrabunemr98/DevOps-BootCamp-Project/blob/main/Jenkinsfile)

![Screenshot from 2023-08-06 01-37-48](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/235a22f5-45b8-48e5-9762-5a9d8085eee8)

5. Launch Jenkins Instance to Configure AWS Credentials and Set Up EKS Access:
```
sudo chown -R ubuntu:ubuntu /home/ubuntu/.aws
aws configure
chmod 600 /home/ubuntu/.aws/credentials
aws eks --region us-east-1 update-kubeconfig --name Sprints-EKS-Cluster
```
![WhatsApp Image 2023-08-06 at 2 06 27 AM](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/8d1dea34-857a-4541-8807-863a164241a3)

5. Get Admin Password for Jenkins from output of running bash script:
![Screenshot from 2023-08-06 02-24-46](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/af17f296-3fe0-42ee-a096-71e094af0484)

6. Access Jenkins Web Interface:
```
"public_ip_jenkins_instance":8080
```
7. Configure Jenkins Credentials:
- Add GitHub credentials to Jenkins for accessing your repository.
- Add AWS credentials for interacting with AWS services.
![WhatsApp Image 2023-08-06 at 2 30 14 AM](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/fae8e3d0-dedc-4643-8f4a-e2f750b97a05)

8. Set Up Pipeline and Webhook:
- Configure a GitHub webhook to trigger the pipeline on repository pushes. 
![Screenshot from 2023-08-05 20-16-08](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/f6c393aa-ddf2-465a-a170-4ef360e835c5)
------------------------------------
![Screenshot from 2023-08-05 20-11-08](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/2160f0fb-c18e-4938-bea9-72b5da11845b)
--------------------------------------------------------
- Create a pipeline in Jenkins using a Jenkinsfile.
![Screenshot from 2023-08-06 02-37-38](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/84548a7d-f090-48d8-8eb4-f540cad11a60)
----------------------------------------------
9. Access Web Application:
- After the pipeline completes, find the DNS of the web server from the pipeline outputs.
![Screenshot from 2023-08-05 23-10-53](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/1b183134-ff5f-414b-89cd-d94865fa4e98)
--------------------------------------------
![Screenshot from 2023-08-05 22-27-03](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/51b8687e-d742-4c1b-96d7-d5873e44f494)
-------------------------------------------------------
![Screenshot from 2023-08-05 22-43-23](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/bff6266f-8aaa-43a4-9636-24164d5af76b)
---------------------------------------------------
![Screenshot from 2023-08-05 22-48-22](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/1c6a2898-979a-4796-94f4-1b5ad6a7d8b8)
-----------------------------------------------------
![Screenshot from 2023-08-05 22-48-35](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/ad04da23-0f9a-48c8-8a56-43d234200c1c)
10. Check Kubernetes Cluster Status:
- Run the following commands to check the status of different Kubernetes components.
```
kubectl get nods
kubectl get pods
kubectl get pv
kubectl get pvc
kubectl get svc
```
![Screenshot from 2023-08-05 22-35-32](https://github.com/amrabunemr98/DevOps-BootCamp-Project/assets/128842547/83be057c-e319-4479-bf92-335cad759bab)
> [!IMPORTANT]
> Ensure that you have the necessary permissions and security measures in place for accessing AWS resources and sensitive data.
> Make sure the bash script and Jenkinsfile are appropriately structured and contain the necessary commands and configurations.

## :tada: Conclusion:-
- Through a series of carefully orchestrated steps, I've built a fully automated CI/CD pipeline for a web application, leveraging an array of powerful tools and technologies. Throughout this project, I've gained practical experience in provisioning infrastructure with Terraform, configuring services using Ansible, containerizing applications with Docker, orchestrating deployments on Kubernetes, and automating workflows with Jenkins. By seamlessly integrating these tools, so i have demonstrated a mastery of essential DevOps practices that empower efficient and reliable software delivery.

## :open_book: Additional Resources and References
- Throughout of this project, I found the following resources to be immensely helpful:
1. Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
2. Ansible Documentation: https://docs.ansible.com/ansible/latest/index.html
3. Kubernetes Documentation: https://kubernetes.io/docs/home/

> [!NOTE]
> Remember that these steps provide a high-level overview of the process. You'll need to fill in the specific commands and configurations for each step based on your project's requirements and your environment. Test each step thoroughly and make adjustments as needed to ensure a smooth and successful deployment process.
