#!/bin/bash
set -x

apt-get install -y kubeadm=1.26.3-00 kubelet=1.26.3-00 kubectl=1.26.3-00
apt-mark hold kubelet kubectl kubeadm
systemctl enable kubelet --now
echo "source <(kubectl completion bash)" >> ~/.bashrc
