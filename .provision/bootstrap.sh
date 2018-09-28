#!/usr/bin/env bash

## --- Update OS --- ##
sudo apt-get update
#sudo apt-get upgrade -y

## --- Install programming essential bundles --- ##
cd ~
sudo apt-get install build-essential -y

## --- Install Certbot --- ##
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -y python-certbot-nginx

## --- Install NGINX web server --- ##
sudo apt-get install -y nginx
# copy webserver file over
sudo cp /vagrant/.provision/default /etc/nginx/sites-available
# restart NGINX service
sudo systemctl restart nginx
# allow NGINX through firewall
sudo ufw allow 'Nginx Full'
sudo ufw enable

## --- Install PostgreSQL --- ##
sudo apt-get install postgresql postgresql-contrib
sudo -u postgres createuser -s root

## --- Install NodeJS v8.x --- ##
sudo curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs

## --- Install PM2 Process Manager --- ###
sudo npm install -g pm2
# automate PM2 service to start at startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

## --- Install Sympm to link node modules properly --- ##
## uncomment this section only if you cannot run this script in admin/superuser mode ##
## sudo npm install -g sympm

## --- Install Serve --- ##
sudo npm install -g serve

## --- Set up the application servers --- ##
cd /vagrant
sudo ./setup-servers.sh

## --- Freeze applications currently running in PM2 --- ##
## This allows for the applications to start up on server startup ##
sudo pm2 startup