#!/bin/bash
sudo su
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
cd /var/www/html
wget https://github.com/7hundredtech/E-Commerce/raw/main/E-Commerce.zip
unzip E-Commerce.zip
cp -r furni-1.0.0/* /var/www/html/
rm -rf furni-1.0.0 E-Commerce.zip
