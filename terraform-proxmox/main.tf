provider "proxmox" {
  pm_api_url          = var.api_url
  pm_api_token_id     = var.api_token_id
  pm_api_token_secret = var.api_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "cloudinit-test" {
  count       = terraform.workspace == "default" ? 2 : 1
  name        = "tf-${terraform.workspace}-0${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name
  agent       = 0
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  bios        = "seabios"
  disk {
    slot    = 0
    size    = "20G"
    type    = "virtio"
    storage = "STORAGE"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  connection {
    host        = var.ips[count.index]
    user        = var.user
    private_key = file(var.ssh_keys["priv"])
    agent       = false
    timeout     = "3m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf -y update",
      "sudo dnf install -y python3",
    ]
  }

  provisioner "local-exec" {
    working_dir = terraform.workspace == "default" ? "../terraform-ansible-default" : "../terraform-ansible-staging"
    command     = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, main.yml"
  }

}