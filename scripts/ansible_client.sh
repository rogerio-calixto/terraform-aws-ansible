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

while [ ! -f /tmp/id_rsa.pub ]
do
   aws s3 cp ${s3-bucket-dest}id_rsa.pub /tmp
   sleep 5
done

cat /tmp/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub