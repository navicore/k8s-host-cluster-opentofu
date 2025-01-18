# provider "kubernetes" {
#   config_path = "${path.module}/kubeconfig.yaml"
# }

# provider "helm" {
#   kubernetes {
#     config_path = "${path.module}/kubeconfig.yaml"
#   }
# }
#
#
# resource "kubernetes_namespace" "ingress_nginx" {
#   metadata {
#     name = "ingress-nginx"
#   }
# }
#
# resource "helm_release" "nginx_ingress" {
#   name       = "ingress-nginx"
#   namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
#   chart      = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   version    = "4.10.1"
#
#   set {
#     name  = "controller.extraArgs.enable-ssl-chain-completion"
#     value = "true"
#   }
#
#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
#
#   depends_on = [kubernetes_namespace.ingress_nginx]  # Ensure namespace is created first
# }
#
# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "1.13.0"  # Use the latest stable version
#   namespace  = "cert-manager"
#
#   create_namespace = true
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }
#
# resource "null_resource" "letsencrypt_issuer" {
#   provisioner "local-exec" {
#     command = <<EOT
#       cat > /tmp/letsencrypt-prod.yaml <<EOF
#       apiVersion: cert-manager.io/v1
#       kind: ClusterIssuer
#       metadata:
#         name: letsencrypt-prod
#       spec:
#         acme:
#           server: https://acme-v02.api.letsencrypt.org/directory
#           email: "${var.letsencrypt_email}"
#           privateKeySecretRef:
#             name: letsencrypt-prod
#           solvers:
#           - http01:
#               ingress:
#                 class: nginx
#       EOF
#       kubectl apply -f /tmp/letsencrypt-prod.yaml
#     EOT
#   }
#
#   depends_on = [helm_release.cert_manager, local_file.kubeconfig]
# }
