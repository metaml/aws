#!/bin/bash

if [ -b /dev/xvdb ]; then
    sudo umount -f /dev/xvdb
    sudo mkfs -t ext4 /dev/xvdb
    sudo mkdir -p /data
    sudo mount /dev/xvdb /data
    sudo chmod a+rwx /data
fi
if [ -b /dev/xvdc ]; then
    sudo umount -f /dev/xvdc
    sudo mkfs -t ext4 /dev/xvdc
    sudo mkdir -p /log
    sudo mount /dev/xvdc /log
    sudo chmod a+rwx /log
fi

if [ ! -f "/etc/fstab-" ]; then sudo mv -f /etc/fstab /etc/fstab-; fi
sudo sh -c "cat /etc/fstab- | egrep -v '(/dev/xvdb|/dev/xvdc)' > /etc/fstab"
for i in $(cat /etc/fstab- | egrep '(/dev/xvdb|/dev/xvdc)' | awk '{print $2}'); do
    sudo umount -f $i
done
sudo mkdir -p /data /log
sudo sh -c "echo '/dev/xvdb /data ext4 defaults,nofail,discard 0 2' >> /etc/fstab"
sudo sh -c "echo '/dev/xvdc /log  ext4 defaults,nofail,discard 0 2' >> /etc/fstab"

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y --force-yes oracle-java8-installer
sudo update-java-alternatives -s java-8-oracle

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c 'echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list'
sudo apt-get update -y
sudo apt-get install -y lxc-docker
for i in docker.socket docker.service; do
    sudo systemctl unmask $i
    sudo systemctl enable $i
done
sudo addgroup ubuntu docker
