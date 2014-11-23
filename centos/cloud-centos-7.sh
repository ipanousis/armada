#!/bin/bash
yum install -y docker
sed -i 's/OPTIONS=\(.*\)/OPTIONS=\1 -H tcp:\/\/0.0.0.0:4243 -H unix:\/\/\/var\/run\/docker.sock/g' /etc/sysconfig/docker
systemctl enable docker.service
systemctl restart docker.service

# enable root login
echo "root:root" | chpasswd
sed -i 's/PermitRootLogin .*/PermitRootLogin yes/g' /etc/ssh/sshd_config
mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRnUNT2DRsYrFDvMKg4Wvg1VhztMUGIaBRnFrkqZpA9EjVaCgaWe8MlJw9A9e4hksNSq17rbQVyFOcJF8ri548WluK/8OV6tgSYuFqvbdskdtW1avyvrbomyYHj8mMxCkByUm2InHc7ZuBtLG7Ps1TXnwE45cLn60z6Uk9s8yuMdS7iuFeixEoj/naQX5DJVhWbXbm//Fiv3ukZ76ohE8C7cMjwMYN+BaM5GLhPksW8ip4CHc1NNGTAg1T9RXSHwSsllHSvDKS23fmPgyHOnitreItcYyS60XN8g/pth0/0Vrmo7oomkWkifflTAaZzc8ejgpmdmSU5nKLA/fzCq+B ypanousi@ypanousi-ThinkPad-W520" >> /root/.ssh/authorized_keys
service sshd restart

# install zfs for flocker
KERNEL_RELEASE=`uname -r`
yum install -y https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y kernel-devel-$KERNEL_RELEASE kernel-headers-$KERNEL_RELEASE 
yum localinstall -y --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm
yum install -y zfs

# install flocker
yum install -y git gcc python-pip python-devel
pip install --upgrade pip
pip install --quiet https://storage.googleapis.com/archive.clusterhq.com/downloads/flocker/Flocker-0.3.2-py2-none-any.whl

# create zfs pool
mkdir -p /opt/flocker
truncate --size 1G /opt/flocker/pool-vdev
zpool create flocker /opt/flocker/pool-vdev

