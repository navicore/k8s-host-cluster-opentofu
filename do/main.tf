provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "host_cluster" {
  name    = "navinet"
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

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.host_cluster.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig.yaml"
}

