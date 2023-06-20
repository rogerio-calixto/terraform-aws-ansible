#!/bin/bash
apt-get update
apt-get -y upgrade
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible