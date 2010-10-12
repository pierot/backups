#!/bin/bash

# SETUP
cd ~/.backups

# MYSQL
rsync -av /usr/local/var/mysql/ ./mysql

# APACHE
rsync -av /private/etc/hosts ./apache
rsync -av /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -av /private/etc/apache2/httpd.conf ./apache

# SAVE
git add .
git commit -a -m "backup completed"
git push origin master