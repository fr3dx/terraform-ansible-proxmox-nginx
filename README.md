Simple Terraform / Ansible project deploying cloud image VM on Proxmox (Template + cloud-init)


--
Prerequisites
--

export TF_VAR_api_url="https://{{ your_proxmox_url }}:8006/api2/json"
export TF_VAR_api_token_id='{{ your_token }}'
export TF_VAR_api_token_secret="{{ your_secret }}"
export TF_VAR_ssh_key="{{ your_ssh_pub_key }}"
export TF_VAR_ssh_password="{{ your_ssh_passwd }}"
export TF_VAR_user="{{ your_ssh_username }}"

--
Alma Linux

wget https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-8.5-20211119.x86_64.qcow2

qm create 9000 --name "alma-cloudinit-tmplt" --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk 9000 AlmaLinux-8-GenericCloud-8.5-20211119.x86_64.qcow2 local-btrfs
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-btrfs:9000/vm-9000-disk-0.raw
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --scsi1 local-btrfs:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm template 9000


qm clone 9000 8000 --name alma-vm1
qm set 8000 --sshkey ~/.ssh/id_rsa.pub
qm set 8000 --ipconfig0 ip=192.168.99.28/24,gw=192.168.99.1
qm start 8000

--
Ubuntu Linux

wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img

qm create 9001 --name "ubuntu-cloudinit-tmplt" --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk 9001 focal-server-cloudimg-amd64-disk-kvm.img local-btrfs
qm set 9001 --scsihw virtio-scsi-pci --scsi0 local-btrfs:9001/vm-9001-disk-0.raw
qm set 9001 --boot c --bootdisk scsi0
qm set 9001 --scsi1 local-btrfs:cloudinit
qm set 9001 --serial0 socket --vga serial0
qm template 9001

qm clone 9001 8001 --name ubuntu-vm1
qm set 8001 --sshkey ~/.ssh/id_rsa.pub
qm set 8001 --ipconfig0 ip=192.168.99.28/24,gw=192.168.99.1
qm start 8001

sudo mv /var/lib/dpkg/updates/0001 /var/lib/dpkg/updates/0001.bak