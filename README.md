# K3s Deployment using Terraform

This repository sets up a lightweight **K3s Kubernetes cluster** using Terraform. The setup includes:

- One control-plane node
- Two worker nodes
- Cloud-init-based provisioning
- SSH key injection for secure access

---

## 🔧 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- A public SSH key (e.g., from `~/.ssh/id_rsa.pub`)
- A cloud provider set up in your Terraform configuration (e.g., AWS, Proxmox, etc.)

---

## 🚀 Deployment Steps

### 1. Clone the repository

```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo



### 2. Deploy the Control-Plane
 


```bash
   cd control-plane
   terraform init
   terraform plan
   terraform apply



  - This will spin up the control-plane node and generate a k3s-token.txt file required for worker nodes to join the cluster.



### 3. Copy the K3s Token to Worker Cloud-Init Files

Once the control-plane is up:

1. Open the generated k3s-token.txt (usually found in the control-plane/ directory)
2. Copy the contents of k3s-token.txt
3. Paste it into the cloud-init configuration files for both workers:
    - workers/worker1cloudinit.yaml
    - workers/worker2cloudinit.yaml

Paste the token in the appropriate section (look for a placeholder like {{YOUR-K3S-TOKEN}}).

**Also, make sure your public SSH key is included in all cloud-init files (for access)**



### 4. Deploy the Worker Nodes



```bash
   cd workers/
   terraform init
   terraform plan
   terraform apply



This will provision the worker nodes and join them to the K3s cluster.


