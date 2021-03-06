Overview
=====

This project sets up a flocker cluster (https://docs.clusterhq.com/en/latest/) on CentOS with registering containers on etcd (https://github.com/coreos/etcd) and exposing public containers ports on sub-domain host names using hipache (https://github.com/hipache/hipache).

E.g. if a container named 'elasticsearch-1' is exposing interla port 9200, then that port will be available at http://elasticsearch-1.your-own-public-domain.com

Optionally, a RESTful interface has been written (https://github.com/ipanousis/armada-rest) for easy of interaction with the flocker-deploy function.

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

* Modify all references to "flocker.kalamia.in" in this codebase (a 'sed' command should do the trick) to be "your.own.domain" and populate your DNS server with:
```
172.28.128.3 *.your.own.domain
172.28.128.4 *.your.own.domain
172.28.128.3 your.own.domain
172.28.128.4 your.own.domain
```
where 172.28.128.3 and 172.28.128.4 are the publicly visible IPs of your nodes.

* populate ~/.ansible_hosts with the IPs of the VMs, e.g.
```
[flocker]
172.28.128.3
172.28.128.4
[flocker:vars]
ansible_ssh_user=root
```
* If the private network of the new cluster will not be eth0, modify network interface name in these files;
```
containers/etcd_register/etcd_register.playbook
containers/hipache/hipache.playbook
```
Project is set up for Google Compute Engine so it uses *eth0* by default. It is *enp0s8* for virtualbox.
* Upload public key
```
$ ansible-playbook centos/control-ssh-bootstrap.playbook
$ ansible-playbook centos/flocker-ssh-bootstrap.playbook
```
* Flocker deploy etcd, hipache's redis and armada-rest RESTful deployment interface
```
$ rm application.yml ; cat containers/etcd/fig.yml containers/hipache_redis/fig.yml containers/armada_rest/fig.yml >> application.yml
$ flocker-deploy deployment.yml application.yml
```
* [Optional] If using armada-rest on top of armada, then at this stage you should upload the started flocker container definitions to etcd:
```
$ curl -L -XPUT flocker.kalamia.in:4001/v2/keys/flocker/applications/definitions/etcd          -d value="`cat containers/etcd/fig.yml`"
$ curl -L -XPUT flocker.kalamia.in:4001/v2/keys/flocker/applications/definitions/hipache_redis -d value="`cat containers/hipache_redis/fig.yml`"
```
* Install etcd register, redis register and hipache on the cluster
```
$ ansible-playbook containers/etcd_register/etcd_register.playbook
$ ansible-playbook containers/redis_register/redis_register.playbook
$ ansible-playbook containers/hipache/hipache.playbook
```

* Then you can either: append these lines to application.yml
```
elasticsearch:
  image: dockerfile/elasticsearch
  ports:
    - "9200:9200"
```
* and add "elasticsearch" to one of your nodes in deployment.yml
* run this
```
$ flocker-deploy deployment.yml application.yml
```
* and as soon as that commands finishes, within a few seconds, you'll have a elasticsearch node accessible at "http://elasticsearch.your.own.domain"
* Otherwise you can use armada-rest...


GOOGLE PROVIDER SETUP
=====

```
$ vagrant plugin install vagrant-google
```

* In the step of modifying the private network interface name, use *eth0* unless another private network has been setup.

* Within the firewall rules of the private network, the minimal requirement is that all nodes (as well as any user accessing the cluster from outside) have access to all ports exposed by other nodes in the cluster.


