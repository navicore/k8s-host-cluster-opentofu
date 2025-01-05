
```
tofu init

echo 'do_token = "your-digitalocean-api-token"' > terraform.tfvars
echo 'letsencrypt_email = "you@yourdomain.com"' >> terraform.tfvars

tofu plan

tofu apply -target=local_file.kubeconfig
tofu apply
```

