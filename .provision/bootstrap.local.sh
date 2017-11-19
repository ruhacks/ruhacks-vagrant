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
sudo cp /vagrant/.provision/default.local /etc/nginx/sites-available
sudo mv /etc/nginx/sites-available/default.local /etc/nginx/sites-available/default

# restart NGINX service
sudo systemctl restart nginx
# allow NGINX through firewall
sudo ufw allow 'Nginx Full'
sudo ufw enable

## --- Install NodeJS v6.x --- ###
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

## --- Generate SSL certificate --- ##
## refer to https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04#step-2-—-setting-up-nginx
# sudo certbot --nginx -d ruhacks.com -d www.ruhacks.com -d 2017.ruhacks.com
# sudo certbot renew --dry-run