resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
}


################################################
# Firewall – Kubernetes API Server (master only)
################################################
resource "google_compute_firewall" "allow_k8s_apiserver" {
  name    = "allow-k8s-apiserver"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = ["k8s-control-plane"]
}

########################################
# Firewall – Kubelet (master ↔ worker)
########################################
resource "google_compute_firewall" "allow_kubelet" {
  name    = "allow-kubelet"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["10250"]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = [
    "k8s-control-plane",
    "k8s-node"
  ]
}

#######################################################
# Firewall – Control plane internal ports (master only)
#######################################################
resource "google_compute_firewall" "allow_control_plane_internal" {
  name    = "allow-control-plane-internal"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = [
      "10257", # controller-manager
      "10259"  # scheduler
    ]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = ["k8s-control-plane"]
}

############################################
# Firewall – NodePort services (worker only)
############################################
resource "google_compute_firewall" "allow_nodeport" {
  name    = "allow-nodeport"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = ["k8s-node"]
}

###########################################
# Firewall – Calico VXLAN (worker ↔ worker)
###########################################
resource "google_compute_firewall" "allow_calico_vxlan" {
  name    = "allow-calico-vxlan"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = ["k8s-node"]
}
