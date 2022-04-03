variable "api_url" {
  default = "var.api_url"
}
variable "api_token_id" {
  default = "var.api_token_id"
}
variable "api_token_secret" {
  default = "var.api_token_secret"
}
variable "ssh_key" {
  default = "var.ssh_key"
}
variable "proxmox_host" {
  default = "pve"
}
variable "template_name" {
  default = "alma-cloudinit-tmplt"
}
variable "ips" {
  description = "IPs of the VMs, respective to the hostname order"
  type        = list(string)
  default     = ["192.168.99.231", "192.168.99.232"]
}
variable "ssh_keys" {
  type = map(any)
  default = {
    pub  = "~/.ssh/tf.pub"
    priv = "~/.ssh/tf"
  }
}
variable "ssh_password" {
  default = "var.ssh_password"
}
variable "user" {
  default     = "var.user"
  description = "User used to SSH into the machine and provision it"
}