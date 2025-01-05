output "kubeconfig_path" {
  value = "${path.module}/kubeconfig.yaml"
}

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.host_cluster.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig.yaml"
}
