# Installation and setup of libvirt-terraform to use at a local machine. 
Ideal for homelab.
# CentOs 9
# Data structure of HCL

```console
wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip
unzip terraform_1.3.9_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

```console
sudo dnf install http://mirror.stream.centos.org/9-stream/CRB/x86_64/os/Packages/libvirt-devel-8.9.0-2.el9.x86_64.rpm
```

```console
mkdir -p ~/.terraform.d/plugins
cd ~/.terraform.d/plugins
wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.7.1/terraform-provider-libvirt_0.7.1_linux_amd64.zip
```

```console
unzip terraform-provider-libvirt_0.7.1_linux_amd64.zip -d ~/.terraform.d/plugins/
```


## *Testing*

Create a file .tf with this settings:
 ```console
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}
```

and than use:
```console
terraform init
```


# The hierarchy of the code structure explained:

### 1 - Provider
This block defines 'libvirt' as provider and specifies URI for the libvirt daemon.
It's responsible to configure the connection to the underlying infrastructure.

### 2-  Network
This block defines a network named "example_network" using the "libvirt_network" resource. 
It specifies the name of the network and the mode of the network (in this case, "nat" which stands for network address translation). 
It also defines an IP address management (IPAM) block, which specifies the type of IP address management to use (in this case, "dhcp").

### 3 - Volume
This block defines a disk volume named "example_disk" using the "libvirt_volume" resource.
It specifies the name of the disk volume, the name of the storage pool it will be assigned to, and the capacity of the disk.

### 4 - VM
This block defines a virtual machine named "example_vm" using the "libvirt_domain" resource. 
It specifies the name of the virtual machine, the amount of memory to allocate, and the number of virtual CPUs to use.

It also defines a disk block which attaches the disk volume defined earlier to the virtual machine. 
Additionally, it defines a network interface block that attaches the virtual machine to the default network, sets a pre-defined MAC address, and specifies the name of the network bridge to use.

### 5 - Main
And the main file it's all of this together. 
Each section or block is separated by a blank line, and nested blocks are indented to show their relationship to their parent block.
