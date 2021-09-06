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
hostnamectl set-hostname worker-product-01

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

# Install kubelet

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

yum install -y -q kubelet kubeadm --disableexcludes=kubernetes
systemctl enable kubelet
systemctl start kubelet

# sysctl
cat >>/etc/sysctl.d/k8s.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

fi

#########################################################################################
# SECTION 3: Config Join Cluster K8s
# join cluster
# curl -s http://node1/join-cluster.sh | bash
#

# reboot server
reboot
