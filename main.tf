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

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.host_cluster.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig.yaml"
}

resource "kubernetes_storage_class" "do_block_storage" {
  metadata {
    name = "do-block-storage"
  }

  storage_provisioner = "dobs.csi.digitalocean.com"

  depends_on = [local_file.kubeconfig]
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"  # Use the latest stable version
  namespace  = "ingress-nginx"

  create_namespace = true
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.13.0"  # Use the latest stable version
  namespace  = "cert-manager"

  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "null_resource" "letsencrypt_issuer" {
  provisioner "local-exec" {
    command = <<EOT
      cat > /tmp/letsencrypt-prod.yaml <<EOF
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-prod
      spec:
        acme:
          server: https://acme-v02.api.letsencrypt.org/directory
          email: "${var.letsencrypt_email}"
          privateKeySecretRef:
            name: letsencrypt-prod
          solvers:
          - http01:
              ingress:
                class: nginx
      EOF
      kubectl apply -f /tmp/letsencrypt-prod.yaml
    EOT
  }

  depends_on = [helm_release.cert_manager, local_file.kubeconfig]
}
