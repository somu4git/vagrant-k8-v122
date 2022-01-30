# vagrant-k8-v122

## Prerequisites

1. Working Vagrant setup
2. 10 Gig + RAM workstation as the Vms use 3 vCPUS and 4+ GB RAM

## For MAC Users

Latest version of Virtualbox for Mac/Linux can cause issues because you have to create/edit the /etc/vbox/networks.conf file and add:
<pre>* 0.0.0.0/0 ::/0</pre>

So that the host only networks can be in any range, not just 192.168.56.0/21 as described here:
https://discuss.hashicorp.com/t/vagrant-2-2-18-osx-11-6-cannot-create-private-network/30984/23

## Usage/Examples

To provision the cluster, execute the following commands.

```shell
git clone https://github.com/somu4git/vagrant-k8-v122.git
cd vagrant-k8-v122
vagrant up
```

## Set Kubeconfig file varaible to access the cluster from local machine

```shell
cd vagrant-k8-v122
cd configs
export KUBECONFIG=$(pwd)/config
```

or you can copy the config file to .kube directory.

```shell
cp config ~/.kube/
```

## Kubernetes Dashboard URL

To access the dashboard on your local workstation you need to create a secure channel to your k8 cluster.



```shell
$ kubectl proxy

Access console in the browser 

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
```

## Kubernetes login token

Vagrant up will create the admin user token and saves in the configs directory.

```shell
cd vagrant-k8-v122
cd configs
cat login_token
```

## To shutdown the cluster, 

```shell
vagrant halt (will poweroff the vms)
```
## To restart the cluster,

```shell
vagrant up
```

## To delete the cluster, 

```shell
vagrant destroy -f
```
