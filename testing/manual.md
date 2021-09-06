### Steps Deploy
1. Step: setup k8s
- master: run script setup-master.sh
- worker: run script setup-worker.sh

2. Setup nfs server
- run setup-nfs.sh

3. Deploy nfs provisioner on k8s
```console
   helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

   helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
     --set nfs.server=172.16.10.106 \
     --set nfs.path=/nfs-vol
```
4. Test
```console
   kubectl apply -f test-claim.yaml
```

### Ref
    Viettel VKE
    https://drive.google.com/file/d/1EcuTIUB37mEq4oVcKfQmQYaYHYNE-54i/view?usp=sharing

    StorageClass
    https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
    https://www.youtube.com/watch?v=X48VuDVv0do&t=21s
    https://www.youtube.com/watch?v=DF3v2P8ENEg

    ----
    https://medium.com/@myte/kubernetes-nfs-and-dynamic-nfs-provisioning-97e2afb8b4a9
    https://itnext.io/configure-an-nfs-storage-class-on-an-existing-kubesphere-cluster-and-create-a-persistentvolumeclaim-c4d4dc82442f