#!/bin/bash

echo -n ":: BACKUPS :: STARTING" | logger

# SETUP
cd ~/.backups

# LAUNCHAGENT FILE
echo -n ":: BACKUPS :: ... LaunchAgent File" | logger

rsync -a /Users/pieterm/Library/LaunchAgents/be.wellconsidered.backups ./

# MONGODB
echo -n ":: BACKUPS :: ... MongoDB Databases" | logger

rsync -a /usr/local/var/mongodb/ ./mongodb

# MYSQL
echo -n ":: BACKUPS :: ... MySQL Databases" | logger

rsync -a /usr/local/var/mysql/ ./mysql

# APACHE
echo -n ":: BACKUPS :: ... Apache Config Files / Host File" | logger

rsync -a /private/etc/hosts ./apache
rsync -a /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -a /private/etc/apache2/httpd.conf ./apache

# INFO
echo -n ":: BACKUPS :: ... Brew, Gem & RVM Lists" | logger

which brew | awk '{print $0}' | while read f; do "$f" list > ./info/brew.txt; done
which gem | awk '{print $0}' | while read f; do "$f" list > ./info/gem.txt; done
which rvm | awk '{print $0}' | while read f; do "$f" list > ./info/rvm.txt; done

# SSH
rsync -a ~/.ssh/* ./ssh

# SYNC TO DROPBOX
echo -n ":: BACKUPS :: ... Syncing Apache, MySQL & MongoDB Backups" | logger

rsync -a ./apache ./mysql ./mongodb ~/Documents/Dropbox/Private/macprox/settings/devenv/

# SAVE
echo -n ":: BACKUPS :: ... Commit / Push Info & Config FIles" | logger

git add .
git commit -a -m "backup completed"
git push origin master

echo -n ":: BACKUPS :: ENDING" | logger