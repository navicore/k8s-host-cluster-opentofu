
```
kubectl apply -f my-vcluster-ingress.yaml
kubectl get ingress -n team-x
kubectl get svc -n ingress-nginx
kubectl describe ingress my-vcluster-ingress -n team-x
```

Record the IP address and use it below.

```
./create-dns-record.sh navicore.tech my-vcluster 203.0.113.42
```

todo: tf enable this workflow for arbitrary vclusters

