#!/bin/bash
# Source: http://redd.it/1oidk8
debootstrap --arch amd64 wheezy /your/install/path http://ftp.us.debian.org/debian` #debootstrap to some folder
#Any other pre-installation configuration, ie setup /etc/networking/interfaces, etc.
#Launch into vm (or do a chroot)
#Fix locales, install keyring, do a full aptitude dist-upgrade -y
#get the list of standard packages from tasks
PACKAGES_STANDARD=`tasksel --task-packages standard | tr "\\n" " "`
PACKAGES_EXTRA='ufw ntp ntpdate openssh-server vim rsync screen dnsutils nmap zip unzip rar unrar htop postfix'
PACKAGES_DEV='build-essential git subversion'

#remove packages -- packages with a _ after the name will be purged -- this
#just basically rectifies the package resolution taken from the standard
#package list so that no unnecessary packages are installed
PACKAGES_TOPURGE='vim-tiny_ exim4_ exim4-base_ exim4-config_ exim4-daemon-light_'

#run the install via aptitude
DEBIAN_FRONTEND=noninteractive aptitude -y install $PACKAGES_STANDARD $PACKAGES_EXTRA $PACKAGES_DEV $PACKAGES_TOPURGE * Any post-installation configuration

#Run post-installation cleanup jobs, ie aptitude clean
#Reboot machine/vm (if applicable)
