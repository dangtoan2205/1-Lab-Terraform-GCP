resource "google_compute_instance" "vm" {
  for_each = var.instances

  name         = each.key
  machine_type = each.value.machine_type
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    source = google_compute_disk.boot[each.key].id
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    dynamic "access_config" {
      for_each = each.value.public_ip ? [1] : []
      content {}
    }
  }

  metadata = merge(
    var.common_metadata,
    lookup(each.value, "metadata", {}),
    {
      ssh-keys = local.ssh_metadata
    }
  )

  tags = each.value.tags

  labels = merge(
    var.common_labels,
    lookup(each.value, "labels", {})
  )

  metadata_startup_script = each.value.startup_script

  lifecycle {
    ignore_changes = [
      boot_disk
    ]
  }
}
