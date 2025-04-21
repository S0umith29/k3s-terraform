resource "proxmox_virtual_environment_file" "worker2cloudinit_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"
  source_raw {
    file_name = "worker2cloudinit-user-data.yml"
    data      = <<EOF
#cloud-config
hostname: worker2
packages:
  - qemu-guest-agent
  - curl
users:
  - name: soumith
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqlVXhh5pO9CtcBDCVLQs9WQFjbA2GpgBpD106LicgZVWFwH0MYFodhhJEY2927ts6vP4jftBZP1KI8HjTOEFkbNkOiRTRo5Dag4VONjG6L+OrxqpvfbhSMTJkSu59b7fJZdX5VNrHU/QYXjNNUcPELMNUKSO/IKUUxYtEXZSG8gPomjLcUI+K6Ew8Q8okyzHfK3d+O5gUKYrhue6unqutCdTo+eUR7OSyLRCAyJiccaxC+X8OW2ZdvdWT77VAfJbOBFVZkqOXE7q5aGpvHwZupuOkjALSJw8UPXMFKV+EwjE6kx8hOO5Yu6xzYB4v7yHlk0bK7kMMjKOq5FSsAbl1kmV8c1ZkBQRNrngah0CdA8R8MsDEoDvZnq5XfDCwNQfwWhe5tL2SZOdgpDHRbr3fdH+l+lFaaNIso6RdbWkzUJ1tK2aNxDkSufZPYC5SzQqfw8HNSbvu+AKHa0noCil9Y5F0EFc/1usand0pbSDoNgS8PDB7TMvoV3ceEpQuzjc9k1frPYQmO6kXeYT+SPMxnk07+94/eQftsv7CtpnYX9n5CcwihKd1HtxjeAAxX299E4iCCdrj2zGlPh2U3AhR9QGlg6QqZ/HOo/11ocOtha5ITgEhNj+qdeuuNPNhLps7qm0FoineEcDt/BThfPekWJqWgrh2oMrnKcW8cepMJw== skuppave@odu.edu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash

runcmd:
  - echo "Cloud-Init started" > /root/cloud-init-start.log
  - systemctl enable qemu-guest-agent || echo "Failed to enable qemu-guest-agent" >> /root/cloud-init-error.log
  - systemctl start qemu-guest-agent || echo "Failed to start qemu-guest-agent" >> /root/cloud-init-error.log
  - curl -sfL https://get.k3s.io | K3S_URL=https://172.18.6.105:6443 K3S_TOKEN="K1049daac3105ed7f8feea9173d9ea96a2bea9b4b66b69749457e29090db43326b5::server:521d42babfdd18797b681bf4592917a0" sh -
  - systemctl enable k3s || echo "Failed to enable k3s agent" >> /root/cloud-init-error.log
  - systemctl start k3s || echo "Failed to start k3s agent" >> /root/cloud-init-error.log
  - echo "Cloud-Init completed" > /root/cloud-init.log

EOF
  }
}
