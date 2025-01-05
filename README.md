create cluster
=============

```
tofu init

echo 'do_token = "your-digitalocean-api-token"' > terraform.tfvars
echo 'letsencrypt_email = "you@yourdomain.com"' >> terraform.tfvars

tofu plan -target=local_file.kubeconfig
tofu apply -target=local_file.kubeconfig -auto-approve
tofu plan
tofu apply -auto-approve
```

delete cluster
=============

```
kubectl --kubeconfig kubeconfig.yaml delete storageclass do-block-storage
tofu destroy -auto-approve

```
