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

# portfolio-website folder

mkdir portfolio-website
cd portfolio-website
aws s3 cp ${s3-bucket-portfolio-website} . --recursive

cd ..

# creates inventory

echo -e "[app]\n\n[portfolio]\n" > inventory

# creates playbook-app.yml

echo "- name: use nginx role playbook" > playbook-app.yml
echo "  hosts: app" >> playbook-app.yml
echo -e "  become: true\n" >> playbook-app.yml
echo "  pre_tasks:" >> playbook-app.yml
echo -e "    - debug:" >> playbook-app.yml
echo -e "        msg: 'starting webserver configuration'\n" >> playbook-app.yml

echo "  roles:" >> playbook-app.yml
echo -e "    - nginx\n" >> playbook-app.yml

echo "  post_tasks:" >> playbook-app.yml
echo "    - debug:" >> playbook-app.yml
echo "        msg: 'webserver configuration successful'" >> playbook-app.yml

# creates playbook-portfolio.yml

echo "- name: use nginx role playbook" > playbook-portfolio.yml
echo "  hosts: db" >> playbook-portfolio.yml
echo -e "  become: true\n" >> playbook-portfolio.yml
echo "  pre_tasks:" >> playbook-portfolio.yml
echo -e "    - debug:" >> playbook-portfolio.yml
echo -e "        msg: 'starting portfolio configuration'\n" >> playbook-portfolio.yml

echo "  roles:" >> playbook-portfolio.yml
echo -e "    - nginx\n" >> playbook-portfolio.yml

echo "  post_tasks:" >> playbook-portfolio.yml
echo "    - debug:" >> playbook-portfolio.yml
echo "        msg: 'portfolio configuration successful'" >> playbook-portfolio.yml

# creates roles folder

mkdir roles
cd roles
ansible-galaxy init nginx

cd nginx/tasks

# creates app configuration

echo "- name: update cache" > main-app.yml
echo "  apt:" >> main-app.yml
echo -e "    update_cache: yes\n" >> main-app.yml
echo "- name: install nginx" >> main-app.yml
echo "  apt:" >> main-app.yml
echo -e "    name: nginx\n" >> main-app.yml
echo "- name: copy contents from /ansible-projects/website to /var/www/html" >> main-app.yml
echo "  copy:" >> main-app.yml
echo "    src: /ansible-projects/website/" >> main-app.yml
echo "    dest: /var/www/html/" >> main-app.yml
echo "    directory_mode:" >> main-app.yml
echo "  tags:" >> main-app.yml
echo "    - dircontent" >> main-app.yml

# creates portfolio configuration

echo "- name: update cache" > main-portfolio.yml
echo "  apt:" >> main-portfolio.yml
echo -e "    update_cache: yes\n" >> main-portfolio.yml
echo "- name: install nginx" >> main-portfolio.yml
echo "  apt:" >> main-portfolio.yml
echo -e "    name: nginx\n" >> main-portfolio.yml
echo "- name: copy contents from /ansible-projects/website to /var/www/html" >> main-portfolio.yml
echo "  copy:" >> main-portfolio.yml
echo "    src: /ansible-projects/portfolio-website/" >> main-portfolio.yml
echo "    dest: /var/www/html/" >> main-portfolio.yml
echo "    directory_mode:" >> main-portfolio.yml
echo "  tags:" >> main-portfolio.yml
echo "    - dircontent" >> main-portfolio.yml

cd /ansible-projects

# creates ansible app script

echo "#!/bin/bash" > ansible-script-app.sh
echo "ansible-playbook -i /ansible-projects/inventory playbook-app.yml" >> ansible-script-app.sh

# creates ansible portfolio script

echo "#!/bin/bash" > ansible-script-portfolio.sh
echo "ansible-playbook -i /ansible-projects/inventory playbook-portfolio.yml" >> ansible-script-portfolio.sh