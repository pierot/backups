#!/bin/bash

# SETUP
cd ~/.backups

# LAUNCHAGENT FILE
rsync -a /Users/pieterm/Library/LaunchAgents/be.wellconsidered.backups ./

# MONGODB
rsync -a /usr/local/var/mongodb/ ./mongodb

# MYSQL
rsync -a /usr/local/var/mysql/ ./mysql

# APACHE
rsync -a /private/etc/hosts ./apache
rsync -a /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -a /private/etc/apache2/httpd.conf ./apache

# INFO
which brew | awk '{print $0}' | while read f; do "$f" list > ./info/brew.txt; done
which gem | awk '{print $0}' | while read f; do "$f" list > ./info/gem.txt; done
which rvm | awk '{print $0}' | while read f; do "$f" list > ./info/rvm.txt; done

# SYNC TO DROPBOX
rsync -a ./apache ./mysql ./mongodb ~/Documents/Dropbox/Private/macprox/settings/devenv/

# SAVE
git add .
git commit -a -m "backup completed"
git push origin master