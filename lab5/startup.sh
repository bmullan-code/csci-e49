#!/bin/bash
# Scrip to setup httpd server and copy the php and inc files
sudo yum update -y
sudo yum install -y httpd php php-mysqlnd
sudo systemctl enable --now httpd

sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R root:www /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec sudo chmod 2775 {} +
sudo find /var/www -type f -exec sudo chmod 0664 {} +

sudo cd /var/www
sudo mkdir /var/www/inc
sudo cd /var/www/inc
sudo cp /home/ec2-user/dbinfo.inc /var/www/inc
sudo cp /home/ec2-user/lab3.php /var/www/html

