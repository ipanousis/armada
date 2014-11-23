----------------------------
FLOCKER CLUSTER SETUP
----------------------------

1. vagrant up

2. flocker-deploy deployment.yml containers/etcd/fig.yml

3. on each flocker node:

scp containers/docker_register/docker_register.service root@<node>:/usr/lib/systemd/system/docker_register.service
--------------------------------
HOST_IP=$(ip -4 addr show enp0s8 | egrep -o "([0-9]+\.){3}[0-9]+" | egrep -v "255$")
echo "HOST_IPV4=$HOST_IP" >> /etc/environment
systemctl enable docker_register.service
systemctl start docker_register.service
--------------------------------

4. flocker-deploy deployment.yml containers/hipache_redis/fig.yml

5. on each flocker node:

scp centos/hipache-centos-7/* root@<node>:
--------------------------------
yum -y install npm
npm install -g hipache
cp hipache.service /usr/lib/systemd/system/hipache.service
cp hipache.json /etc/hipache.json
systemctl enable hipache.service
systemctl start hipache.service
--------------------------------


TODO:

----- TRIGGER THIS WHEN ETCD IS UPDATED BY DOCKER-GEN ------

redis-cli rpush "frontend:etcd.localhost" "etcd"
redis-cli rpush "frontend:etcd.localhost" "http://localhost:4001"

----- TRIGGER THIS WHEN ETCD IS UPDATED BY DOCKER-GEN ------
