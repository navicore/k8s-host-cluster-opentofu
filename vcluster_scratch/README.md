
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
kubectl apply -f my-vcluster-ingress.yaml
kubectl get ingress -n team-x
kubectl get svc -n ingress-nginx
kubectl describe ingress my-vcluster-ingress -n team-x
```

```
vcluster connect my-vcluster --namespace team-x --server https://my-vcluster.navicore.tech
```

