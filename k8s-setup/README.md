Setup
=============

```
tofu init

echo 'letsencrypt_email = "you@yourdomain.com"' >> terraform.tfvars

cp ../do/kubeconfig.yaml .
# or
cp ../aws/kubeconfig.yaml .

./create.sh

```

Clean Up
=============

```
./destroy.sh

```
