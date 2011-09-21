#!/usr/bin/env bash

wget -N --quiet https://raw.github.com/pierot/server-installer/master/lib.sh; . ./lib.sh

############################################################################### 
 
install_dir='.backups'     
default_install_dir="$HOME/$install_dir"     
 
############################################################################### 
 
_usage() {                 
  _print "                 
 
Usage:              install.sh -d ['.backups'] 
 
Remote Usage:       bash <( curl -s https://raw.github.com/pierot/backups/master/install.sh ) [-d '.backups'] 
 
Options: 
  
  -h                Show this message 
  -d '.backups'   Install directory (always in $HOME folder)
  " 
 
  exit 0 
}  
 
############################################################################### 
 
while getopts :hd: opt; do  
  case $opt in 
    h) 
      _usage 
      ;; 
    d) 
      install_dir="$HOME/$OPTARG"
      ;; 
    *) 
      _error "Invalid option received" 
 
      _usage 

      exit 0
      ;;
  esac 
done

############################################################################### 

_print "Installing backups files ***********************"

  cd "$HOME" 

_print "Removing current backups installation"

  rm -rf "$install_dir"

_print "Check if 'git' exists"

  GIT_INSTALLED=true

  hash git 2>&- || { _error "I require git but it's not installed!"; GIT_INSTALLED=false; }

  if ! $GIT_INSTALLED; then
    while true
    do
      read -p "Do you want me to install git? (sudo needed) [Y/N] " RESP

      case $RESP
        in
        [yY])
          _check_root
          _system_installs_install 'git'

          GIT_INSTALLED=true
          break
          ;;
        [nN])
          break
          ;;
        *)
          echo "Please enter Y or N"
      esac
    done
  fi

_print "Cloning into repo"

  if $GIT_INSTALLED; then
    git clone git://github.com/pierot/backups.git "$install_dir"
  fi

  if [ ! -d "$install_dir" ]; then
    _error "Backups doesn't seem to be installed correctly. Aborting"

    exit 1
  else
    _print "Installing cron"

    rm -rf "$HOME/Library/LaunchAgents/be.noort.backups"

    cp "$install_dir/be.noort.backups" "$HOME/Library/LaunchAgents/be.noort.backups"

    cd "$HOME/Library/LaunchAgents/"

    launchtl unload be.noort.backups
    launchtl load be.noort.backups
    launchtl list be.noort.backups

    _print "Installation finished **************************"

    if $install_dir -ne $default_install_dir; then
    	_print "You will need to change the $HOME/Library/LaunchAgents/be.noort.backups so it directs to the directory you choose"
    fi
  fi

_cleanup_lib
