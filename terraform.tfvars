project_id = "my-project-test-485708"

common_labels = {
  env = "dev"
}

instances = {
  main = {
    machine_type = "e2-standard-2"
    disk_size    = 100
    disk_type    = "pd-balanced"

    tags      = ["lab-node"]
    public_ip = true

    startup_script = <<-EOT
      #!/bin/bash
      set -e
      apt-get update -y
      apt-get install -y nginx
      systemctl enable --now nginx
    EOT
  }
}
