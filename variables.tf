variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "zone" {
  type    = string
  default = "asia-southeast1-b"
}

variable "vpc_name" {
  type    = string
  default = "qlts-vpc"
}

variable "subnet_name" {
  type    = string
  default = "qlts-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "instance_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "private_key_filename" {
  type    = string
  default = "key-rsa.pem"
}

variable "write_private_key_file" {
  type    = bool
  default = true
}

variable "common_labels" {
  type    = map(string)
  default = {}
}

variable "common_metadata" {
  type    = map(string)
  default = {}
}

variable "instances" {
  type = map(object({
    machine_type = string
    disk_size    = number

    tags = list(string)

    image     = optional(string)
    disk_type = optional(string, "pd-balanced")

    public_ip = optional(bool, true)
    static_ip = optional(bool, true)

    labels   = optional(map(string), {})
    metadata = optional(map(string), {})

    startup_script = optional(string)

    service_account = optional(object({
      email  = string
      scopes = list(string)
    }))
  }))
}
