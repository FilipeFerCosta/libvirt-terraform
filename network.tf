resource "libvirt_network" "example_network" {
  name = "example-network"
  mode = "nat"

  ipam {
    type = "dhcp"
  }
}
