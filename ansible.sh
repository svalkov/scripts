#!/bin/bash
set -ex

# Add EPEL repository

osV=$(rpm --eval '%{centos_ver}')

if [ "$osV" == "8" ]; then
    cd /etc/yum.repos.d/
    sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
    sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

    sudo yum install -y epel-release
    sudo sed -i 's/metalink/#metalink/g' /etc/yum.repos.d/epel*
    sudo sed -i 's|#baseurl=https://download.example/pub/|baseurl=https://mirror.init7.net/fedora/|g' /etc/yum.repos.d/epel*
else
   sudo yum install -y epel-release
fi

sudo yum install -y ansible
