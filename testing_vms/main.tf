# Informing the dmacvicar/libvirt as provider

terraform {
    required_providers {
        libvirt = {
            source  = "dmacvicar/libvirt"
            version = "0.7.1"
        }
    }
}

# Listing some variables

# Number of VM's that are being deployed 
variable "VM_COUNT" {
    default = 1
    type    = number
}

# The username of the VM
variable "VM_USER" {
    default = "developer"
    type    = string
}

# The name of the VM
variable "VM_HOSTNAME" {
    default = "vm"
    type    = string
}

# The image file for the VM
variable "VM_IMG_URL"{
    default = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
    type    = string
}

# Informing the image format
variable "VM_IMG_FORMAT" {
    default = "qcow2"
    type    = string
}

# Defining the network interface
variable "VM_CIDR_RANGE" {
    default = "10.0.0.40/24"
    type    = string
}


# Instance the provider

provider "libvirt" {
    uri = "qemu:///system"    
}


# Reference to the cloud_init file
data "template_file" "user_data" {
    template = file("${path.module}/cloud_init.cfg")
    vars = {
        VM_USER = var.VM_USER
    }
}

# Reference to the network_config file
data "template_file" "network_config" {
    template = file("${path.module}/network_config.cfg")
}


# Defining resourcers 

# Informing the POOL, where is 'housed' virtual machine boot volumes and the cloud init ISO files
# Where the pool name is the vm name
resource "libvirt_pool" "vm" {
    name = "${var.VM_HOSTNAME}_pool"
    type = "dir"
    path = "/tmp/terraform-provider-libvirt-pool-ubuntu"
}

# Informing the boot volume characteristic with the variables defined previously
resource "libvirt_volume" "vm" {
    count   = var.VM_COUNT
    name    = "${var.VM_HOSTNAME}-${count.index}_volume.${var.VM_IMG_FORMAT}"
    pool    = libvirt_pool.vm.name
    source  = var.VM_IMG_URL
    format  = var.VM_IMG_FORMAT
}

# Defining the public network for the VM
resource "libvirt_network" "vm_public_network" {
      name      = "${var.VM_HOSTNAME}_network"
      mode      = "nat"
      domain    = "${var.VM_HOSTNAME}.local"
      address   = ["${var.VM_CIDR_RANGE}"]
      dhcp {
        enable = true
      }
      dns {
        enable = true
      }
}

# Defining the cloudinit network
resource "libvirt_cloudinit_disk" "cloudinit" {
    name            = "${var.VM_HOSTNAME}_cloudinit.iso"
    user_data       = data.template_file.user_data.rendered
    network_config  = data.template_file.network_config.rendered
    pool            = libvirt_pool.vm.name
}

# Defining the resources for the VM
resource "libvirt_domain" "vm" {
  count     = var.VM_COUNT
  name      = "${var.VM_HOSTNAME}-${count.index}"
  memory    = "1024"
  vcpu      = 1

  cloudinit = "${libvirt_cloudinit_disk.cloudinit.id}"

  # TODO: Automate the creation of public network
  network_interface {
    network_id      = "${libvirt_network.vm_public_network_id}"
    network_name    = "${libvirt_network.vm_public_network.name}"
  }


  console {
    type            = "spices"
    listen_type     = "address"
    autoport        = true
  }


  disk {
    volume_id = "${libvirt_volume.vm[count.index].id}"
  }

  graphics {
    type            = "spices"
    listen_type     = "address"
    autoport        = true
  }

}