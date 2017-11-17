#!/usr/bin/env bash

## --- Start up Server Process --- ##
cd /vagrant/2017
sudo pm2 start server.js --name 2017
cd /vagrant/2018
sudo pm2 start server.js --name 2018
# sudo pm2 startup