# Defining the image format
variable "libvirt_img_format" {
  default = "qemu:///system"
  type    = string
  description = "(optional) default is qemu:///system"
}

# Number of VM's that are being deployed 
variable "libvirt_ubuntu_count" {
  default = 1
  type    = number
}

# The username of the VM
variable "libvirt_user" {
  default = "developer"
  type    = string
}

# Defining the name of the VM
variable "libvirt_hostname" {
  default = "vm"
  type    = string
}

# Defining the network interface
variable "libvirt_cidr_range" {
  default = "10.0.0.40/24"
  type    = string
}

# Defining the network mode
variable "libvirt_network_mode" {
  type    = string
  default = "nat"
}
