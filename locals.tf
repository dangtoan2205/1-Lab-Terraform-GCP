locals {
  ssh_metadata = "${var.ssh_username}:${tls_private_key.ssh_key.public_key_openssh}"
}
