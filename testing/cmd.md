### Commands kubectl (k)
```console
k get node -o wide
k cluster-info
k get pods -w
k get pv,pvc

# xóa taint trên node master.xtl cho phép tạo Pod
kubectl taint node master.xtl node-role.kubernetes.io/master-

# thêm taint trên node master.xtl ngăn tạo Pod trên nó
kubectl taint nodes master.xtl node-role.kubernetes.io/master=false:NoSchedule
```