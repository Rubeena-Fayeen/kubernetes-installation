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
echo "{ \n \"exec-opts\": [\"native.cgroupdriver=systemd\"]\n}" | sudo tee /etc/docker/daemon.json 1>/dev/null
sudo systemctl daemon-reload 1>/dev/null
sudo systemctl restart docker 1>/dev/null
echo "Done"

echo "STEP 6: Installing Kubernetes master components"
echo "Installing kubelet"
apt-get install -y kubelet=1.23.8-00 kubeadm=1.23.8-00 kubectl=1.23.8-00 kubernetes-cni 1>/dev/null
echo "Done"

echo -e "\n################################################################ \n"
echo "Kubernetes node template is now created"
echo "Create an AMI from this node to create worker nodes"
echo "Note: This node will be your master node"
echo -e "\n################################################################ \n"
exit
