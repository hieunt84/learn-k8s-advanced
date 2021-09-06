### Steps Deploy
1. Step: setup k8s
- master: run script setup-master.sh
- worker: run script setup-worker.sh

2. Setup nfs server
- run setup-nfs.sh on worker01

3. Deploy nfs provisioner on k8s
```console
   helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

   helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
     --set nfs.server=192.168.1.243 \
     --set nfs.path=/nfs-vol
```
4. Testing
```console
   kubectl apply -f test-claim.yaml
```