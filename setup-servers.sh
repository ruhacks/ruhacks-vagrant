#!/usr/bin/env bash

## --- Clone the repositories for server --- ##

## --- 2017 --- ##
# check that the 2017 dir doesn't exist
if [ ! -d '2017' ]; then
  cd /vagrant

  echo 'Grabbing 2017 repo from Github'
  sudo git clone https://github.com/ruhacks/2017-website 2017

  echo 'Creating copy of .env.template and renaming to .env'
  sudo cp /vagrant/2017/.env.template /vagrant/2017/.env

  if [ `command -v npm` != '' ]; then
    cd /vagrant/2017

    echo 'Installing node modules'
    sudo npm install
  fi
fi

## --- 2018 --- ###
# check that the 2018 dir doesn't exist
if [ ! -d '2018' ]; then
  cd /vagrant

  echo 'Grabbing 2018 repo from Github'
  sudo git clone https://github.com/ruhacks/2018-website-placeholder 2018

  echo 'Creating copy of .env.template and renaming to .env'
  sudo cp /vagrant/2018/.env.template /vagrant/2018/.env

  if [ `command -v npm` != '' ]; then
    cd /vagrant/2018

    echo 'Installing node modules'
    sudo npm install
  fi
fi

if [ `command -v pm2` != '' ]; then
  cd /vagrant/2017

  echo 'Starting up 2017 server using pm2'
  sudo pm2 start server.js --name 2017

  cd /vagrant/2018

  echo 'Starting up 2018 server using pm2'
  sudo pm2 start server.js --name 2018
fi