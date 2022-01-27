# vagrant-k8-v122

## Prerequisites

1. Working Vagrant setup
2. 10 Gig + RAM workstation as the Vms use 3 vCPUS and 4+ GB RAM

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
