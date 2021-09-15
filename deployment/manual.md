### Env
- localhost/on-primes/cloud vps
- production/staging/test

### Architecture
- 4 node :  1 master, 2 worker , 1 nfs server

### Steps Deploy
1. Step 01: deploy cluster k8s
- cd deployment/01.cluster
- vagrant up

2. Step 02: deploy nfs provisioner on k8s
- cd deployment/02.nfs-provisioner
- run install.sh

3. Step 03: deploy metallb on k8s
- cd deployment/03.metallb
- run install.sh

4. Step 04: deploy ingress-nginx-controller on k8s
- cd deployment/04.ingress
- run install.sh

5. Step 05: deploy app for deployment
- cd deployment/05.deploy-app-deployment
- deploy myapp1
- deplay myapp2

### Operation
- kubectl