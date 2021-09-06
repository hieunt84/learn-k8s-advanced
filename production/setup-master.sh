#!/bin/bash
# set -e

##########################################################################################
# SECTION 1: PREPARE

# update system
sleep 1
yum -y clean all
yum -y update
sleep 1

# config timezone
timedatectl set-timezone Asia/Ho_Chi_Minh

# disable SELINUX
setenforce 0 
sed -i 's/enforcing/disabled/g' /etc/selinux/config

# disable firewall
systemctl stop firewalld
systemctl disable firewalld

# config hostname
hostnamectl set-hostname master-product-01

# config file host
cat >> "/etc/hosts" <<END
192.168.1.242 master-product-01
192.168.1.243 worker-product-01
192.168.1.244 worker-product-02
192.168.1.245 nfs-product-01 
END

# config network, config in vagrantfile in dev

# Tắt swap: Nên tắt swap để kubelet hoạt động ổn định.
sed -i '/swap/d' /etc/fstab
swapoff -a

##########################################################################################
# SECTION 2: INSTALL 

# install docker

if [ ! -d /etc/systemd/system/docker.service.d ]; then

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
 "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "log-opts": {
 "max-size": "100m"
 },
 "storage-driver": "overlay2",
 "storage-opts": [
   "overlay2.override_kernel_check=true"
 ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
fi

# Install kubelet, kubeadm and kubectl

if [ ! -f /etc/yum.repos.d/kubernetes.repo ]; then
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y -q kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet
systemctl start kubelet

# sysctl
cat >>/etc/sysctl.d/k8s.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

fi
#End Install kubelet

# Install apache for join cluster automatically
# yum install httpd -y
# systemctl enable httpd
# systemctl start httpd

#########################################################################################
# SECTION 3: CONFIG K8S CLUSTER

# Configure NetworkManager before attempting to use Calico networking.
if [ ! -f /etc/NetworkManager/conf.d/calico.conf ]; then
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF
fi

# Setup Kubernetes Cluster
kubeadm init --pod-network-cidr=192.168.100.0/24 --apiserver-advertise-address=192.168.1.242

# Setup kubectl for user root on Master Node
export KUBECONFIG=/etc/kubernetes/admin.conf
echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> ~/.bash_profile

# Install Calico
kubectl apply -f https://docs.projectcalico.org/v3.17/manifests/calico.yaml

# Đến đây Master Node của Kubernetes Cluster đã sẵn sàng,
# cho Worker Node tham gia (join) vào

# Save command to join cluster
sudo kubeadm token create --print-join-command > /var/www/html/join-cluster.sh

# copy config cluster
cp /etc/kubernetes/admin.conf /var/www/html/config
chmod 755 /var/www/html/config

# reboot server
reboot




