#!/bin/bash

echo -n ":: BACKUPS :: STARTING" | logger

# SETUP
cd ~/.backups/backups

# LAUNCHAGENT FILE
echo -n ":: BACKUPS :: ... LaunchAgent File" | logger

rsync -a ~/Library/LaunchAgents/be.wellconsidered.backups ./../

# MONGODB
echo -n ":: BACKUPS :: ... MongoDB Databases" | logger

rsync -a /usr/local/var/mongodb/ ./mongodb

# MYSQL
echo -n ":: BACKUPS :: ... MySQL Databases" | logger

rsync -a /usr/local/var/mysql/ ./mysql

# POSTGRESQL
echo -n ":: BACKUPS :: ... PostgreSQL Databases" | logger

rsync -a /usr/local/var/postgres/ ./postgres

# APACHE
echo -n ":: BACKUPS :: ... Apache Config Files / Host File" | logger

if [ -d ./apache ]; then
	rm -r apache
	mkdir apache
fi

rsync -a /private/etc/hosts ./apache
rsync -a /private/etc/apache2/extra/httpd-vhosts.conf ./apache
rsync -a /private/etc/apache2/httpd.conf ./apache

# INFO
echo -n ":: BACKUPS :: ... Brew, Gem & RVM Lists" | logger

which brew | awk '{print $0}' | while read f; do "$f" list > ./brew.txt; done
which gem | awk '{print $0}' | while read f; do "$f" list > ./gem.txt; done
which rvm | awk '{print $0}' | while read f; do "$f" list > ./rvm.txt; done

# MM.CFG
echo -n ":: BACKUPS :: ~/mm.cfg" | logger

rsync -a ~/mm.cfg ./

# SSH
echo -n ":: BACKUPS :: ~/.ssh" | logger

rsync -a ~/.ssh/* ./ssh

# HEROKU
if [ -d ~/.heroku ]; then
	rsync -a ~/.heroku/* ./heroku
fi

# DOTCLOUD
if [ -d ~/.dotcloud ]; then
	rsync -a ~/.dotcloud/* ./dotcloud
fi

# VAGRANT
if [ -d ~/.vagrant.d ]; then
	rsync -a ~/.vagrant.d/* ./vagrant.d
fi

# LOCAL VIM FILES
echo -n ":: BACKUPS :: ~/.vim/*.local" | logger

rsync -a ~/.vim/*.local ./vim

# SYNC TO DROPBOX
echo -n ":: BACKUPS :: ... Syncing Apache, MySQL & MongoDB Backups" | logger

mkdir -p ~/Documents/Backups/`ioreg -l | awk '/IOPlatformSerialNumber/ {print $4}' | sed 's|\"||g'`
rsync -au ./ ~/Documents/Backups/`ioreg -l | awk '/IOPlatformSerialNumber/ {print $4}' | sed 's|\"||g'`

# SAVE
echo -n ":: BACKUPS :: ... Commit / Push Info & Config FIles" | logger

git add .
git commit -a -m "backup completed"
git push origin master

echo -n ":: BACKUPS :: ENDING" | logger
