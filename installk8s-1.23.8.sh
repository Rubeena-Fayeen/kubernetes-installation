#!/bin/bash

echo -e "\n################################################################"
echo "#                                                              #"
echo "#                     ***Artisan Tek***                        #"
echo "#                  Kubernetes Installation                     #"
echo "#                                                              #"
echo "################################################################"

echo "Running script with $(whoami)"

echo "STEP 1: Disabling Swap"
sudo swapoff -a 1>/dev/null
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 1>/dev/null
echo "Done"

echo "STEP 2: Installing apt-transport-https"
apt-get install -y apt-transport-https 1>/dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - > /dev/null 2>&1
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
echo "Done"

echo "STEP 3: Updating apt"
apt-get update > /dev/null 2>&1
echo "Updated ...."

echo "STEP 4: Installing Docker"
curl -fsSL https://get.docker.com -o get-docker.sh 
sh get-docker.sh > /dev/null 2>&1
echo "Done"

echo "STEP 5: C-Group Error Fix and Restarting Components"
sudo mkdir -p /etc/docker
echo "{ \n \"exec-opts\": [\"native.cgroupdriver=systemd\"]\n}" | sudo tee /etc/docker/daemon.json 1>/dev/null
sudo systemctl daemon-reload 1>/dev/null
if sudo systemctl restart docker.service; then
  echo "Docker service restarted successfully"
else
  echo "Failed to restart Docker service"
fi

echo "STEP 6: Installing Kubernetes master components"
echo "Installing kubelet, kubeadm, kubectl, and kubernetes-cni"
apt-get install -y kubelet kubeadm kubectl kubernetes-cni 1>/dev/null
if [ $? -eq 0 ]; then
  echo "Kubernetes master components installed successfully"
else
  echo "Failed to install Kubernetes master components"
fi

echo -e "\n################################################################ \n"
echo "Kubernetes node template is now created"
echo "Create an AMI from this node to create worker nodes"
echo "Note: This node will be your master node"
echo -e "\n################################################################ \n"
exit
