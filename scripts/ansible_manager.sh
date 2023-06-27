#!/bin/bash
apt-get update
apt-get -y upgrade
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible unzip
sleep 20

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sleep 10
sudo unzip -u awscliv2.zip
sleep 20
./aws/install
sleep 20
rm -f awscliv2.zip

sleep 10

# # generate ssh-keygen and copy to s3

SSH_KEY="/home/ubuntu/.ssh/id_rsa" \
&& METADATA="ubuntu@ip-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" \
&& USR=$(echo $METADATA | sed s/[.]/-/g) \
&& ssh-keygen -C "$USR" -f "$SSH_KEY" -P "" \
&& sudo chmod 444 $SSH_KEY \
&& aws s3 cp $SSH_KEY.pub ${s3-bucket-dest}