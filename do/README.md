Setup
=============

```
tofu init

echo 'do_token = "your-digitalocean-api-token"' > terraform.tfvars
echo 'letsencrypt_email = "you@yourdomain.com"' >> terraform.tfvars

./create.sh

```

Clean Up
=============

```
./destroy.sh

```
