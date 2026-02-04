output "vm_external_ips" {
  value = {
    for k, v in google_compute_instance.vm :
    k => try(v.network_interface[0].access_config[0].nat_ip, null)
  }
}

output "ssh_commands" {
  value = {
    for k, v in google_compute_instance.vm :
    k => "ssh -i keys/${var.private_key_filename} ${var.ssh_username}@${v.network_interface[0].access_config[0].nat_ip}"
  }
}

