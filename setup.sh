#!/bin/bash
raspi-config

. .profile

adduser chris
adduser chris sudo

apt-get update -y && apt-get upgrade -y
apt-get install samba samba-common-bin git screen avahi-daemon screen tmux curl ranger dialog htop boxes usbmount wicd-curses -y
rpi-update

nano /etc/samba/smb.conf

smbpasswd –a root
smbpasswd –a pi
smbpasswd –a chris

/etc/init.d/samba stop 
/etc/init.d/samba start

nano /etc/hosts
nano /etc/hostname
/etc/init.d/hostname.sh

wicd-curses

reboot
