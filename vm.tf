resource "libvirt_domain" "example_vm" {
  name   = "example-vm"
  memory = "2048"
  vcpu   = "2"

  disk {
    volume_id = "${libvirt_volume.example_disk.id}"
  }

  network_interface {
    network_name = "default"
    mac          = "52:54:00:12:34:56"
    bridge       = "virbr0"
  }
}
