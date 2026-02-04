resource "google_compute_disk" "boot" {
  for_each = var.instances

  name  = "${each.key}-boot-disk"
  zone  = var.zone
  type  = each.value.disk_type
  size  = each.value.disk_size
  image = each.value.image != null ? each.value.image : var.instance_image

  lifecycle {
    prevent_destroy = true
  }

  labels = merge(
    var.common_labels,
    lookup(each.value, "labels", {})
  )
}