#!/bin/bash

# Run Terraform
run_terraform() {
    echo "Running Terraform..."
    cd /home/abunemr/Bootcamp/Sprints-Project/Terraform
    terraform init
    terraform apply -auto-approve
    jenkins_ip=$(terraform output Public-ip-jenkins)
    cd -
    echo "Terraform execution completed."
}
# Update inventory
update_inventory() {
    echo "Updating Ansible inventory..."
    inventory_file="/home/abunemr/Bootcamp/Sprints-Project/jenkins-ansible/inventory.txt"

    # Replace the IP address of the target host in the inventory file
    echo -e "jenkins ansible_host=${jenkins_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/abunemr/sprint-project.pem" > "${inventory_file}"

    echo "Ansible inventory updated."
}
# Function to run Ansible
run_ansible() {
    echo "Running Ansible..."
    cd /home/abunemr/Bootcamp/Sprints-Project/jenkins-ansible/
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook -i inventory.txt playbook.yml
    cd -
    echo "Ansible execution completed."
}


# Main script
echo "Starting to Run script"

# Call the functions to run Terraform and Ansible

#run_terraform
echo "Done Finished Terraform SuccessFully"
#update_inventory
echo "Done Updated Inventory SuccessFully"
sleep 5
run_ansible
echo "Done Finished Ansible SuccessFully"
echo "Script execution finished."