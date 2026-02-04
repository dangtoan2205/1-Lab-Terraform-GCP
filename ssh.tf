resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  count = var.write_private_key_file ? 1 : 0

  filename        = "${path.module}/keys/${var.private_key_filename}"
  content         = tls_private_key.ssh_key.private_key_pem
  file_permission = "0600"
}

