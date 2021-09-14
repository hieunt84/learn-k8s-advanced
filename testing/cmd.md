### Command kubectl
```console
kubectl get pods -w
kubectl get pv,pvc
```

### Command helm
```console
helm install -f mysql.values hit-mysql bitnami/mysql

helm repo add stable https://charts.kubesphere.io/main
helm install nfs-client stable/nfs-client-provisioner --set nfs.server=172.16.10.106 --set nfs.path=/nfs-vol

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=172.16.10.106 --set nfs.path=/nfs-vol
```