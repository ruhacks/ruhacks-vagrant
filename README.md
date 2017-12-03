# RU Hacks Vagrant

This is used to deploy updates/changes to production as well as set up a development environment locally for use.

There are two machines defined in the `Vagrantfile.template`. One for deploying to DigitalOcean using the Vagrant plugin [vagrant-digitalocean](https://github.com/devopsgroup-io/vagrant-digitalocean) as a provider to manage droplets on DigitalOcean. The other machine is for local development.

## Table of Contents
- [Setup](#setup)
- [Development](#development)
  - [Quick Start](#quick-start)
  - [Managing the nginx server](#managing-the-nginx-server)
    - [Adding applications](#adding-applications)
    - [Issues with Running Local Copy](#issues-with-running-local-copy)
    - [Reference](#reference)
  - [Managing applications](#managing-applications)
    - [Note](#note)
    - [Administration](#administration)
    - [States](#states)
- [Production](#production)
  - [Vagrantfile Modifications](#vagrantfile-modifications)
  - [Deploying](#deploying)
- [Issues](#issues)

## Setup

1. Before setting up Vagrant, you will need to install VirtualBox. Go to this [page](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1) and pick the appropriate installation from version `5.1.30`.
2. Install Vagrant by geting the installation [here](https://releases.hashicorp.com/vagrant/2.0.1/).
3. Get the `Ubuntu Xenial` box by running `vagrant box add ubuntu/xenial --box-version=20171116.0.0` in terminal
4. Install the Vagrant plugins `vagrant-digitalocean` and `vagrant-hostmaster` by running the following in terminal:
    ```
    vagrant plugin install vagrant-digitalocean
    vagrant plugin install vagrant-hostmanager
    ```

    For more details on these plugins, visit their Github repositories:
    - [vagrant-digitalocean](https://github.com/devopsgroup-io/vagrant-digitalocean/)
    - [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
5. Make a copy of `Vagrantfile.template` and rename it `Vagrantfile`
6. __(Optional)__ Modify `Vagrantfile` for managing DigitalOcean droplet (See [Production](#production) for more details)
7. Run `vagrant up ruhacks-local` to setup the vm for development

## Development

### Quick start

Once you have setup according to the instructions above then you can do the following:
- ssh into the machine by running `vagrant ssh ruhacks-local`
- shut the machine down by running `vagrant halt ruhacks-local`
- restart the machine by running `vagrant reload ruhacks-local`
- access the application by going to http://ruhacks.local

### Managing the nginx server

#### Adding applications

1. To add other applications for access on host, modify the `default.local` file in the `.provision` folder. Then ssh into the machine and run
    ```
    sudo cp /vagrant/.provision/default.local /etc/nginx/sites-available/default
    sudo nginx -s reload
    ```
    for the changes to appear.
2. However there is one more step if you want to access it by domain name (i.e. `*.ruhacks.local`):
    - Go to the `Vagrantfile` and add the domain name to `config.hostmanager.aliases`
    - Run `vagrant hostmanager ruhacks-local` to update your hosts file
3. Now you should be able to access the application on host by visiting the new domain name

#### Issues with Running Local Copy

There is a known issue where when static files are updated they may not show up properly when served by NGINX.
An example of this can be found [here](https://web.archive.org/web/20130305235704/http://smotko.si/nginx-static-file-problem/).

The solution is to go to the `/etc/nginx/` directory and edit the `nginx.conf` file by changing the `sendfile` option to `off`.

#### Reference

If you don't know how to configure nginx, please check out the [docs](http://nginx.org/en/docs/)

### Managing applications

Currently we're using [PM2](http://pm2.keymetrics.io/) to keep applications running in the background as well as starting up on system startup.

#### Note

When you ssh into the machine, you will notice that the pm2 processes are not run under the current user which you logged in as. When the machine was setup, it was done as _root_ so to change to _root_ user run `sudo su` to change user to _root_.

The name of a process will be its filename unless the `--name` option is provided. If the `--name` option is provided then the process name will be whatever is provided to that option.

#### Administration
- To view current applications processes run `pm2 status`
- To view output of applications run `pm2 logs` or to view a specific application output run `pm2 logs <process name>`
- To view pm2 status as a dashboard run `pm2 dash`

#### States
- To start an application, `cd` to the application directory and run `pm2 start <filename> [--name <process name>]`.
- To restart an application run `pm2 restart [<process name>|all]`
- To stop an application run `pm2 stop [<process name>|all]`
- To remove an application from pm2 run `pm2 delete [<process name>|all]`
- To make current pm2 processes start on startup run `pm2 startup` - ___note this will reboot the machine___

## Production

### Vagrantfile Modifications

1. Update path to ssh file for `override.ssh.private_key_path`. This ssh file can be found by asking the droplet maintainer.
2. Add in token to `provider.token` for `ruhacks-droplet` machine. This can be found by asking the droplet maintainer or resetting the ruhacks token on DigitalOcean.

### Deploying

___Before deploying make sure your changes work on the dev environment!___

When deploying to droplet make sure to have all the files the server has under its `/vagrant` directory. Then to update the server with your changes run `vagrant rsync ruhacks-droplet`.

_Currently rsyncing is not the best method if you only want to push your changes without having to setup and update the other applications_

If the need arises we'll look into setting up FTP/SFTP or some other method on production server to push changes.

## Issues

Submit an issue if anything does not behave as expected.