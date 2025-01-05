provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "host_cluster" {
  name    = "vcluster-host"
  region  = "sfo2"  # Change to your preferred region
  version = "1.31.1-do.5"

  node_pool {
    name        = "default-pool"
    size        = "s-2vcpu-4gb"
    auto_scale  = true
    min_nodes   = 1
    max_nodes   = 4
  }
}
