WARNING this does not work - the docs for vcluster are lacking.  It seems like
what I want to do requires installing their PaaS/platform stuff that can manage
all cert managers.  Will revisit this...


```
kubectl -n ingress-nginx get service
```
Record the IP address and use it below.

```
./create-dns-record.sh navicore.tech my-vcluster 203.0.113.42
```

Create VCluster
```
vcluster create my-vcluster --namespace team-x
```
Cancel the port-forwarding Ctl-C

Switch back to the host context
```
kubectl config use-context <WHATEVER THE HOST IS>
```

```
kubectl apply -f cluster-issuer.yaml
kubectl apply -f my-vcluster-ingress.yaml
kubectl get ingress -n team-x
kubectl get svc -n ingress-nginx
kubectl describe ingress my-vcluster-ingress -n team-x
```

```
vcluster connect my-vcluster --namespace team-x --server https://my-vcluster.navicore.tech
```

