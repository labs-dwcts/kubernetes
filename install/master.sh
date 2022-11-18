# OS : Ubuntu Server 20.04 LTS
# Kernel : 5.4.0-132-generic
# Kubernetes Master Node
# Kubernetes Version : 1.25.4

#!/usr/bin/env bash

# set -e

# install docker
# pre-requisites
sudo apt update && sudo apt upgrade -y
 
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# add docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# stable repository for docker
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker engine
sudo apt-get update
sudo apt-get install -y \
    docker-ce docker-ce-cli containerd.io

# add user permissions
sudo chmod 666 /var/run/docker.sock
sudo usermod -a -G docker $USER
# newgrp docker


# check docker version
sudo docker version

# add service docker to systemd
sudo systemctl enable docker
sudo systemctl start docker


# install kubernetes
# pre-requisites (master, node)
# swapoff
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab
# check swapoff
swapon -s


# kube-proxy iptables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system


# ufw disable
sudo ufw disable


# install kubelet, kubeadm, kubectl (master, node)
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl


# add google public key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg


# add kubernetes repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


# install kubelet, kubeadm, kubectl (master, node)
sudo apt-get update
sudo apt-get install -y \
    kubelet \
    kubeadm \
    kubectl

# package hold kubelet, kubeadm, kubectl (master, node)
sudo apt-mark hold kubelet kubeadm kubectl


# add service kubelet to systemd
sudo systemctl daemon-reload
sudo systemctl restart kubelet


# /etc/containerd/config.toml
# disabled_plugins delete cli
sudo sed -i '/disabled_plugins/s/^/#/' /etc/containerd/config.toml
sudo systemctl restart containerd


# Set up the Docker daemon
# /etc/docker/daemon.json
if [ -d "/etc/docker" ]; then
    echo "Directory /etc/docker exist"
else
    echo "Folder /etc/docker not exist"
    sudo mkdir /etc/docker
fi

cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
  
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

kubeadm reset --force


# control-plane configuration
sudo kubeadm init


# add kube command to all users
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# kubeadm token save
sudo kubeadm token create --print-join-command > ~/.kube/kubeadm-join.txt


# kubernetes master-node install complete
echo "################################################################################"
echo "Kubernetes master-node install complete."
echo "################################################################################"

# install add-on pod network
sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


# check node status
# kubectl get nodes
echo "################################################################################"
echo "Get nodes#"
echo "################################################################################"
kubectl get nodes -o wide
echo "################################################################################"
echo ""
echo "################################################################################"
echo "Get pods all namespaces#"
echo "################################################################################"
kubectl get pods --all-namespaces
echo "################################################################################"


# To tab autocomplete kubectl commands in bash, run:
# source <(kubectl completion bash)
# echo "source <(kubectl completion bash)" >> ~/.bashrc


# install helm
# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash