resource "libvirt_volume" "example_disk" {
  name      = "example-disk.qcow2"
  pool_name = "default"
  capacity  = "10G"
}
