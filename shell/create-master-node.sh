#!/bin/bash
set -ex

#拉取相关镜像
kubeadm config images pull --config kubeadm.yml
#初始化master节点
kubeadm init --config kubeadm.yml