#!/bin/bash

#отключаю SWAP
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#задаю имя тачке
sudo hostnamectl set-hostname master-1
sudo hostnamectl set-hostname worker-1

#задаем в /etc/hosts имена доменов
192.168.64.9	worker-1
192.168.64.14	master-1

#устанавливаем докер
sudo apt update && sudo apt install -y docker.io  
sudo systemctl enable --now docker

#Устанавливаем пакеты кубер
KUBE_VERSION=1.29.0
ARCH=arm64
DOWNLOAD_URL=https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/${ARCH}

curl -LO ${DOWNLOAD_URL}/kubeadm
curl -LO ${DOWNLOAD_URL}/kubelet
curl -LO ${DOWNLOAD_URL}/kubectl

chmod +x kubeadm kubelet kubectl
sudo mv kubeadm kubelet kubectl /usr/local/bin/

#зависимости:
sudo apt update
sudo apt install -y docker.io conntrack socat cri-tools ethtool
