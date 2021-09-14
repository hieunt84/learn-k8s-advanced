### Env
    - localhost/on-primes/cloud
    - production/staging/testing

### Architecture
    - 4 node :  1 master, 2 worker , 1 nfs server

### Steps Deploy
1. Step 01: deploy cluster k8s
- cd testing/cluster
- vagrant up

2. Step 02: deploy nfs provisioner on k8s
- on master
- run 03-install-nfs-external-provisioner.sh

3. Step 03: Testing
```console
cd nfs-storageclass
kubectl apply -f test-pvc.yaml
```
### Operation
    - kubectl 

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