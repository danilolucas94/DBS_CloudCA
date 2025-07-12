#!/bin/bash

echo -e "\n\e[32m*** Setting Variables for our VM  ***\e[0m"

PROJECT_ID="dbscloudca"
ZONE="us-central1-c"
VM_NAME="webserver-vm"
MACHINE_TYPE="e2-standard-2"
IMAGE_FAMILY="ubuntu-minimal-2204-lts"
IMAGE_PROJECT="ubuntu-os-cloud"
DISK_SIZE="250"
STATIC_IP_NAME="ca-cloud-vm"
FIREWALL_RULE="allow-http-ssh"

echo -e "Variables set"

# Set project
echo -e "\n\e[32m*** Setting Project ID on GCloud  ***\e[0m"
gcloud config set project $PROJECT_ID

echo -e "\n\e[32m*** Reserving a static external IP  ***\e[0m"
gcloud compute addresses create $STATIC_IP_NAME --region=us-central1

echo -e "\n\e[32m*** Creating VM  ***\e[0m"
gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --boot-disk-size=$DISK_SIZE \
  --boot-disk-type=pd-balanced \
  --address=$(gcloud compute addresses describe $STATIC_IP_NAME --region=us-central1 --format='get(address)') \
  --tags=http-server,ssh-server \
  --maintenance-policy=MIGRATE \
  --provisioning-model=STANDARD \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
  --no-shielded-secure-boot \
  --no-shielded-vtpm \
  --no-shielded-integrity-monitoring

# Timer to make sure that our VM is up and running
echo -e "\n\e[32mWaiting for VM initialization...\e[0m"
sleep 30

echo -e "\n\e[32m*** Creating firewall rule to allow HTTP and SSH ***\e[0m"
gcloud compute firewall-rules create $FIREWALL_RULE \
  --allow tcp:80,tcp:22 \
  --target-tags=http-server,ssh-server

sleep 10

echo -e "\n\e[32m*** Connecting using SSH and install Apache and create Hello World file ***\e[0m"
gcloud compute ssh $VM_NAME --zone=$ZONE --command="sudo apt-get update && sudo apt-get install -y apache2 && echo 'Hello World' | sudo tee /var/www/html/index.html"

echo -e "\n\e[32m*** Webserver updated and running ***\e[0m\n"

