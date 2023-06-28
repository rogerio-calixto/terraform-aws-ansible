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

SSH_KEY="/home/ubuntu/.ssh/id_rsa" \
&& METADATA="ubuntu@ip-$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" \
&& USR=$(echo $METADATA | sed s/[.]/-/g) \
&& ssh-keygen -C "$USR" -f "$SSH_KEY" -P "" \
&& sudo chmod 444 $SSH_KEY \
&& aws s3 cp $SSH_KEY.pub ${s3-bucket-dest}

# generate prototype ansible

# project folder

mkdir /ansible-projects
chmod 777 /ansible-projects

cd /ansible-projects

# website folder

mkdir website
cd website
aws s3 cp ${s3-bucket-website} . --recursive
cd ..

# creates inventory

echo -e "[app]\n\n[database]\n" > inventory

# creates playbook.yml

echo "- name: use nginx role playbook" > playbook.yml
echo "  hosts: app" >> playbook.yml
echo -e "  become: true\n" >> playbook.yml
echo "  pre_tasks:" >> playbook.yml
echo -e "    - debug:" >> playbook.yml
echo -e "        msg: 'starting webserver configuration'\n" >> playbook.yml

echo "  roles:" >> playbook.yml
echo -e "    - nginx\n" >> playbook.yml

echo "  post_tasks:" >> playbook.yml
echo "    - debug:" >> playbook.yml
echo "        msg: 'webserver configuration successful'" >> playbook.yml

# creates roles folder

mkdir roles
cd roles
ansible-galaxy init nginx
ansible-galaxy init mysql
cd nginx/tasks

echo "- name: update cache" > main.yml
echo "  apt:" >> main.yml
echo -e "    update_cache: yes\n" >> main.yml
echo "- name: install nginx" >> main.yml
echo "  apt:" >> main.yml
echo -e "    name: nginx\n" >> main.yml
echo "- name: copy contents from /ansible-projects/website to /var/www/html" >> main.yml
echo "  copy:" >> main.yml
echo "    src: files/website/" >> main.yml
echo "    dest: /var/www/html/" >> main.yml
echo "    directory_mode:" >> main.yml
echo "  tags:" >> main.yml
echo "    - dircontent" >> main.yml

cd /ansible-projects

# creates ansible script

echo "#!/bin/bash" > ansible-script.sh
echo "ansible-playbook -i /ansible-projects/inventory playbook.yml" >> ansible-script.sh