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

# # ssh-keygen -b 2048 -C "$email_keygen" -f "$AWS_KEY_PAIR_FILE" -m PEM -P "" -t rsa \
# ssh-keygen -b 2048 -f "$AWS_KEY_PAIR_FILE" -P "" -t rsa \
# && chmod 400 $AWS_KEY_PAIR_FILE \
# && aws s3 cp $AWS_KEY_PAIR_FILE.pub ${s3-bucket-dest}


# metadata="ubuntu@$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" \
#  && usr=$(echo $metadata | sed s/[.]/-/g) \
#  && echo $usr \
#  && ssh-keygen -b 2048 -c "$usr" -f /home/ubuntu/.ssh/clx -P "" -t rsa 


# PRIVATE_IP=curl http://169.254.169.254/latest/meta-data/local-ipv4 && ssh-keygen -b 2048 -c "ubuntu@$PRIVATE_IP" -f /home/ubuntu/.ssh/clx -P "" -t rsa

# ssh-keygen -b 2048 -c "$PRIVATE_IP" -f /home/ubuntu/.ssh/clx -P "" -t rsa \

# && ssh-keygen -b 2048 -C "$USR" -f "$SSH_KEY" -P "" -t rsa \
SSH_KEY="/home/ubuntu/.ssh/id_rsa" \
&& METADATA="ubuntu@ip-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" \
&& USR=$(echo $METADATA | sed s/[.]/-/g) \
&& ssh-keygen -C "$USR" -f "$SSH_KEY" -P "" \
&& chmod 400 $SSH_KEY \
&& aws s3 cp $SSH_KEY.pub ${s3-bucket-dest}