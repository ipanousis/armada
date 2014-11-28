Pre-requisites for the control host
=====

* vagrant >= 1.6.5 (https://www.vagrantup.com/downloads.html)
* ansible >= 1.7.0 (http://docs.ansible.com/intro_installation.html)
```
$ touch ~/.ansible_hosts
$ echo "export ANSIBLE_HOSTS=~/.ansible_hosts" >> ~/.bashrc
$ echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> ~/.bashrc
$ . ~/.bashrc
```
* flocker >= 0.3.2 (find latest version at https://storage.googleapis.com/archive.clusterhq.com)
```
install flocker
$ pip install --quiet https://storage.googleapis.com/archive.clusterhq.com/downloads/flocker/Flocker-0.x.x-py2-none-any.whl
```

FLOCKER CLUSTER SETUP
=====

* vagrant up

* populate ~/.ansible_hosts with the private IPs of the VMs, e.g.
```
[flocker]
172.28.128.3
172.28.128.4
[flocker:vars]
ansible_ssh_user=root
```
* Modify private network interface of cluster in these files;
```
containers/etcd_register/etcd_register.playbook
containers/hipache/hipache.playbook
```
It is *ansible_enp0s8.ipv4.address* for virtualbox, but it will be *ansible_[eth0|eth1].ipv4.address* in most cases. This network should be the same as the network previously setup in ~/.ansible_hosts.
* Upload public key
```
$ ansible-playbook centos/virtualbox-ssh-bootstrap.playbook
```
* Flocker deploy etcd and hipache's redis
```
$ rm application.yml ; cat containers/etcd/fig.yml containers/hipache_redis/fig.yml >> application.yml
$ flocker-deploy deployment.yml application.yml
```
* Install etcd register, redis register and hipache on the cluster
```
$ ansible-playbook containers/etcd_register/etcd_register.playbook
$ ansible-playbook containers/redis_register/redis_register.playbook
$ ansible-playbook containers/hipache/hipache.playbook
```


GOOGLE PROVIDER SETUP
=====

```
$ vagrant plugin install vagrant-google
```
