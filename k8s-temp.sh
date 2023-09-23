#!/bin/bash

sudo apt update


# Set the hostname
sudo hostnamectl set-hostname master

sudo apt install ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 6443
sudo ufw allow 2379:2380/tcp
sudo ufw allow 10250
sudo ufw allow 10259
sudo ufw allow 10257
sudo ufw allow 10248
sudo ufw allow 30000:32767/tcp
apt install -y curl
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.4/cri-dockerd_0.3.4.3-0.ubuntu-focal_amd64.deb
sudo dpkg -i cri-dockerd_0.3.4.3-0.ubuntu-focal_amd64.deb
sudo systemctl start cri-docker.service
sudo systemctl enable cri-docker.service
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo mkdir -p /etc/apt/keyrings/
apt install curl
curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo swapoff -a
