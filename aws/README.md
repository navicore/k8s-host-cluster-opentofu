Setup
=============

## make sure your aws cli user has policies:

  * AmazonEKSWorkerNodePolicy
  * AmazonEC2ContainerRegistryReadOnly
  * AmazonEKS_CNI_Policy

set via:

```
aws iam attach-role-policy \
  --role-name eks-node-group-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
```

```
tofu init

#echo 'do_token = "your-digitalocean-api-token"' > terraform.tfvars

./create.sh

```

Clean Up
=============

```
./destroy.sh

```
