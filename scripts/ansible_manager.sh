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

# generate ssh-keygen and copy to s3

AWS_KEY_PAIR_FILE="/home/ubuntu/.ssh/id_rsa"

ssh-keygen -b 2048 -C "$email_keygen" -f "$AWS_KEY_PAIR_FILE" -m PEM -P "" -t rsa \
&& chmod 400 $AWS_KEY_PAIR_FILE \
&& aws s3 cp $AWS_KEY_PAIR_FILE.pub ${s3-bucket-dest}

# ssh-keygen -q -t rsa -N '' <<< $'\ny' >/dev/null 2>&1 \
# && cd /home/ubuntu/.ssh \
# && aws s3 cp id_rsa.pub ${s3-bucket-dest}