#!/bin/bash

apt-get update && apt-get upgrade -y
apt-get install ansible unzip git -y
mkdir /opt/terraform
cd /opt/terraform
wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip
unzip terraform_0.12.6_linux_amd64.zip
rm terraform_0.12.6_linux_amd64.zip
chmod 777 /opt/terraform/terraform
echo 'export PATH=$PATH:/opt/terraform/' >> ~/.bashrc
cd ~
. ~/.bashrc
