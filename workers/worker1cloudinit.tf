resource "proxmox_virtual_environment_file" "worker1cloudinit_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"
  source_raw {
    file_name = "worker1cloudinit-user-data.yml"
    data      = <<EOF
#cloud-config
hostname: worker1
packages:
  - qemu-guest-agent
  - curl
users:
  - name: soumith
    ssh-authorized-keys:
      - ssh-rsa YOUR_SSH_PUBLIC_KEY
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash

runcmd:
  - echo "Cloud-Init started" > /root/cloud-init-start.log
  - systemctl enable qemu-guest-agent || echo "Failed to enable qemu-guest-agent" >> /root/cloud-init-error.log
  - systemctl start qemu-guest-agent || echo "Failed to start qemu-guest-agent" >> /root/cloud-init-error.log
  - curl -sfL https://get.k3s.io | K3S_URL=https://172.18.6.105:6443 K3S_TOKEN="YOUR_K3S-TOKEN" sh -
  - systemctl enable k3s || echo "Failed to enable k3s agent" >> /root/cloud-init-error.log
  - systemctl start k3s || echo "Failed to start k3s agent" >> /root/cloud-init-error.log
  - echo "Cloud-Init completed" > /root/cloud-init.log

EOF
  }
}
