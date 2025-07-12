**Google Cloud VM Deployment Script**

This repository contains a script to automate the deployment of a Virtual Machine (VM) and associated resources on Google Cloud Platform (GCP). The script provisions a VM instance with a static external IP, configures firewall rules for HTTP and SSH access, and installs a simple web server to demonstrate connectivity.


**Overview**

This project automates the following tasks on Google Cloud:

Creates a Compute Engine VM instance with:
- Minimum 2 vCPUs and 8GB RAM
- 250GB storage
- Ubuntu 22.04 LTS image
- Reserves and assigns a static external IP address
- Configures a firewall rule to allow HTTP (port 80) and SSH (port 22) access
- Installs Apache and hosts a "Hello World" webpage


**Prerequisites**

Before running the script, ensure you have:

- A Google Cloud account with billing enabled
- Google Cloud SDK (gcloud) installed and authenticated on your local machine
- Sufficient IAM permissions to create and manage Compute Engine resources
- Compute Engine and IAM APIs enabled for your project


**Install Google Cloud SDK**

Follow the official guide to install the SDK for your operating system.


**Edit the script variables:**

Open vm-script.sh and set the following variables to match your environment:

PROJECT_ID
ZONE
INSTANCE_NAME
STATIC_IP_NAME

**Make the script executable:**

chmod +x vm-script.sh


**Script Usage**

Run the deployment script:
./vm-script.sh

The script will:

- Set the project
- Reserve a static external IP
- Create a VM instance with the specified configuration
- Configure firewall rules for HTTP and SSH
- Install Apache and deploy a "Hello World" webpage

**Expected Output**

After successful execution:
A VM instance will be running in Compute Engine with a static external IP address.

You can SSH into the VM:

gcloud compute ssh <INSTANCE_NAME> --zone=<ZONE>
Access the "Hello World" webpage in your browser at:
http://<EXTERNAL_IP>

The Compute Engine console will show the VM as "RUNNING".

**Troubleshooting**

- Permission errors: Ensure your user has the necessary IAM roles (e.g., Compute Admin).
- API errors: Double-check that Compute Engine and IAM APIs are enabled.
- Billing issues: Make sure your project has billing enabled.
- Firewall issues: If HTTP/SSH access fails, verify the firewall rules and VM tags.

**Additional Notes**
The script is idempotent: re-running it will not duplicate resources.
Modify the script to customize VM specs, network settings, or web server configuration as needed.
