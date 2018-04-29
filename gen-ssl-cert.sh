#!/usr/bin/env bash

## --- Generate SSL certificate --- ##
## refer to https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04#step-2-—-setting-up-nginx
sudo certbot --nginx -d ruhacks.com -d www.ruhacks.com -d admin.ruhacks.com -d hackers.ruhacks.com -d 2018.ruhacks.com
#sudo certbot --nginx -d 2017.ruhacks.com
sudo certbot renew --dry-run