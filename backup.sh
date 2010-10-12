#!/bin/bash

# SETUP
cd ~/.backups

# MYSQL
DEST = "./mysql"

rsync -av /usr/local/var/mysql/ $DEST

# APACHE
DEST = "./apache"

rsync -av /private/etc/hosts $DEST
rsync -av /private/etc/apache2/extra/httpd-vhosts.conf $DEST
rsync -av /private/etc/apache2/httpd.conf $DEST

# SAVE
DATE = date

git add .
git commit -a -m "backup completed on $DATE"
git push origin master