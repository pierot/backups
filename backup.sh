#!/bin/bash

# SETUP
cd ~/.backups

# MONGODB
rsync -a /usr/local/var/mongodb/ ./mongodb

# MYSQL
rsync -a /usr/local/var/mysql/ ./mysql

# APACHE
rsync -a /private/etc/hosts ./apache
rsync -a /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -a /private/etc/apache2/httpd.conf ./apache

# INFO
brew list > ./info/brew.txt
gem list > ./info/gem.txt
rvm list > ./info/rvm.txt

# SYNC TO DROPBOX
rsync -a ./apache ./mysql ./mongodb ~/Documents/Dropbox/Private/macprox/settings/devenv/

# SAVE
#git add .
#git commit -a -m "backup completed"
#git push origin master