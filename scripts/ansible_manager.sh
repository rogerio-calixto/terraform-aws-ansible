#!/bin/bash
apt-get update
apt-get -y upgrade
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

sleep 15
sudo apt-get install unzip -y
sleep 5
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sleep 5
sudo unzip -u awscliv2.zip
sleep 5
sudo ./aws/install
rm -f awscliv2.zip

# generate ssh-keygen
ssh-keygen -q -t rsa -N '' <<< $'\ny' >/dev/null 2>&1
sleep 5

# copy key-gen for s3
cd /home/ubuntu/.ssh
aws s3 cp id_rsa.pub ${s3-bucket-dest}

