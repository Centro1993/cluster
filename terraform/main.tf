terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.32.2"
    }
  }
}

# export TF_VAR_hcloud_token='##########'
variable "hcloud_token" {
  type = string
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

# Create a new SSH key
resource "hcloud_ssh_key" "jonas-pc" {
  name       = "Jonas PC"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_server" "master-1" {
  name        = "master-1"
  server_type = "cpx11"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  labels = {
    role = "master"
  }

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.5"
  }

  ssh_keys = [
    hcloud_ssh_key.jonas-pc.id
  ]

  # **Note**: the depends_on is important when directly attaching the
  # server to a network. Otherwise Terraform will attempt to create
  # server and sub-network in parallel. This may result in the server
  # creation failing randomly.
  depends_on = [
    hcloud_network_subnet.network-subnet,
    hcloud_ssh_key.jonas-pc
  ]
}

resource "hcloud_server" "node-1" {
  name        = "node-1"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  labels = {
    role = "node"
  }

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.6"
  }

  ssh_keys = [
    hcloud_ssh_key.jonas-pc.id
  ]

  # **Note**: the depends_on is important when directly attaching the
  # server to a network. Otherwise Terraform will attempt to create
  # server and sub-network in parallel. This may result in the server
  # creation failing randomly.
  depends_on = [
    hcloud_network_subnet.network-subnet,
    hcloud_ssh_key.jonas-pc
  ]
}

resource "hcloud_server" "node-2" {
  name        = "node-2"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  labels = {
    role = "node"
  }

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.7"
  }

  ssh_keys = [
    hcloud_ssh_key.jonas-pc.id
  ]

  # **Note**: the depends_on is important when directly attaching the
  # server to a network. Otherwise Terraform will attempt to create
  # server and sub-network in parallel. This may result in the server
  # creation failing randomly.
  depends_on = [
    hcloud_network_subnet.network-subnet,
    hcloud_ssh_key.jonas-pc
  ]
}

