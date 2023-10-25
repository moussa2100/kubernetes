#!/bin/bash

# Update the package list and install necessary packages
sudo apt update
sudo apt install -y wget curl nano git

# Configure kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl settings
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Download and install containerd
wget https://github.com/containerd/containerd/releases/download/v1.6.24/containerd-1.6.24-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.6.24-linux-amd64.tar.gz

# Configure containerd service
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo cp containerd.service /usr/local/lib/systemd/system/
sudo systemctl enable containerd
sudo systemctl start containerd

# Download and install runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64 -P /tmp/
sudo install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc

# Download and install CNI plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz -P /tmp/
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin /tmp/cni-plugins-linux-amd64-v1.2.0.tgz

# Configure containerd with custom config
sudo mkdir -p /etc/containerd
sudo wget https://raw.githubusercontent.com/moussa2100/kubernetes/main/config.toml -O /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd

# Install Kubernetes components
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo mkdir -p /etc/apt/keyrings/
curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Disable swap
sudo swapoff -a
