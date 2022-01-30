#!/bin/bash


MASTER_IP="192.168.212.100"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap >> /root/kubeinit.log 2>/dev/null


echo "[TASK 2.1] Save config to home directory"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Save Configs to shared /Vagrant location
# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.

config_path="/vagrant/configs"

if [ -d $config_path ]; then
   rm -f $config_path/*
else
   mkdir -p /vagrant/configs
fi

cp -i /etc/kubernetes/admin.conf /vagrant/configs/config
touch /vagrant/configs/join.sh
chmod +x /vagrant/configs/join.sh       

kubeadm token create --print-join-command > /vagrant/configs/join.sh

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] Deploy metrics server"

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "[TASK 6]  Install Kubernetes Dashboard"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

echo "[TASK 7] Create Dashboard User k8-admin"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8-admin
  namespace: kube-system
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: k8-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: k8-admin
    namespace: kube-system
EOF

echo "[TASK 8] Copy Dashboard user token to configs"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep k8-admin | awk '{print $1}') >> /vagrant/configs/login_token


sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF

