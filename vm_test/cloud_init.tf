resource "libvirt_cloudinit_disk" "cloud_init" {
  name      = "cloudinit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = var.libvirt_hostname
}
