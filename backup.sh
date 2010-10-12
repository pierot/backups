#!/bin/bash

# SETUP
cd ~/.backups

# MYSQL
rsync -a /usr/local/var/mysql/ ./mysql

# APACHE
rsync -a /private/etc/hosts ./apache
rsync -a /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -a /private/etc/apache2/httpd.conf ./apache

# SYNC TO DROPBOX
rsync -a ./apache ./mysql ~/Documents/Dropbox/Private/macprox/devenv/

# SAVE
git add .
git commit -a -m "backup completed"
git push origin master