#!/bin/bash
set -x

#载入docker镜像源
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
#载入kubeadm、kubelet、kubectl镜像源
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get -y update
#安装基础包
apt-get -y install apt-transport-https ca-certificates curl software-properties-common apt-transport-https ca-certificates wget chrony vim  net-tools bash-completion lrzsz  ipvsadm
chronyc sources
#启用br_netfilter模块
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
modprobe br_netfilter
#修改内核参数
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1 # better than modify /etc/sysctl.conf
vm.swappiness = 0
EOF
sysctl -p
sysctl --system
# 开机载入ipvs模块
cat >> /etc/modules <<EOF
ip_vs_sh
ip_vs_wrr
ip_vs_rr
ip_vs
nf_conntrack
EOF
# 安装containerd
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default >> /etc/containerd/config.toml
sed -i 's#SystemdCgroup = false#SystemdCgroup = true#' /etc/containerd/config.toml
sed -i 's#sandbox_image = "registry.k8s.io/pause:3.8"#sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.9"#' /etc/containerd/config.toml
echo "runtime-endpoint: unix:///run/containerd/containerd.sock" >/etc/crictl.yaml
echo "image-endpoint: unix:///run/containerd/containerd.sock" >>/etc/crictl.yaml
systemctl enable containerd
systemctl restart containerd
systemctl status containerd
#输出containerd配置文件关键配置是否正确
grep 'sandbox_image' /etc/containerd/config.toml
grep 'SystemdCgroup' /etc/containerd/config.toml
