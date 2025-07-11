#!/bin/bash

echo "Setting Variables for our VM"

PROJECT_ID="dbscloudca"
ZONE="us-central1-c"
VM_NAME="webserver-vm"
MACHINE_TYPE="e2-standard-2"
IMAGE_FAMILY="ubuntu-minimal-2204-lts"
IMAGE_PROJECT="ubuntu-os-cloud"
DISK_SIZE="250"
STATIC_IP_NAME="ca-cloud-vm"
FIREWALL_RULE="allow-http-ssh"

# Set project
gcloud config set project $PROJECT_ID

echo "Reserving a static external IP \n" 
gcloud compute addresses create $STATIC_IP_NAME --region=us-central1

echo "Creating VM \n"
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
sleep 30

echo "Creating firewall rule to allow HTTP and SSH \n"
gcloud compute firewall-rules create $FIREWALL_RULE \
  --allow tcp:80,tcp:22 \
  --target-tags=http-server,ssh-server

sleep 10

echo "Connecting using SSH and install Apache and create Hello World file \n"
gcloud compute ssh $VM_NAME --zone=$ZONE --command="sudo apt-get update && sudo apt-get install -y apache2 && echo 'Hello World' | sudo tee /var/www/html/index.html"

