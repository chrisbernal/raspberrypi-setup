#!/bin/bash

echo "please enter a username"
read USER

echo "running raspi-config"
raspi-config

echo "adding new user"
adduser $USER

echo "adding new user to sudoers"
adduser $USER sudo

echo "deleting old .profile"
rm -r -f /home/pi/.profile
rm -r -f /home/$USER/.profile

echo "symlinking new .profile"
ln -s -f setup/.profile /home/pi/
ln -s -f setup/.profile /home/$USER/

echo "reloading bash profile"
. /home/pi/.profile

echo "updating"
apt-get update -y && apt-get upgrade -y

echo "installing utils"
apt-get install samba samba-common-bin git screen avahi-daemon screen tmux curl ranger dialog htop boxes usbmount wicd-curses -y

echo "updating rpi"
rpi-update

echo "edit line 250 of this file to 'no' instead of 'yes'"
rm -rf /etc/samba/smb.conf
cp setup/smb.conf /etc/samba/smb.conf

echo "adding users to samba share"
smbpasswd –a root
smbpasswd –a pi
smbpasswd –a $USER

echo "restarting samba"
/etc/init.d/samba stop 
/etc/init.d/samba start

echo "setting up wifi"
echo "---------------"
echo "use the up and down arrow keys to navigate to your preferred network"
echo "then use the right arrow to config, enter the password and enable auto connect"
echo "then press q to quit"
wicd-curses

echo "rebooting"
reboot
