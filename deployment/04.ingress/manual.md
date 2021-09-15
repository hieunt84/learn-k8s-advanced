### Manual deployment ingress controller
- depoly using helm

- Step 1: config in values.yaml
```console
hostNetwork: true
hostPort:
    enabled: true
kind: DaemonSet
```

- Step 2: create namespace ingress-nginx
```console
kubectl create ns ingress-nginx
```

- Step 3: install ingerss controller
```
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx -f ./values.yaml
``` 

### Ref
```console
- https://www.youtube.com/watch?v=UvwtALIb2U8&t=426s
- https://kubernetes.github.io/ingress-nginx/deploy/#using-helm
```
