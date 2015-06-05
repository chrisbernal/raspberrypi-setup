#!/bin/bash

ask() {
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
        read -p "$1 [$prompt] " REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}




if ask "Set up a new user?"; then
  echo ""
  echo "please enter a username"
  read USER
  adduser $USER
  adduser $USER sudo
  rm -r -f /home/$USER/.profile
  ln -s -f setup/.profile /home/$USER/
fi



if ask "Add .profile for user 'pi'?"; then
  PI=true
  rm -r -f /home/pi/.profile
  ln -s -f setup/.profile /home/pi/
  . /home/pi/.profile
fi




if ask "Run raspi-config?"; then
  raspi-config
fi



if ask "Run apt-get update and apt-get upgrade?"; then
  apt-get update -y && apt-get upgrade -y
  apt-get install rpi-update -y
  rpi-update
fi



if ask "install utils?"; then
  apt-get install samba samba-common-bin git screen avahi-daemon screen tmux curl ranger dialog htop boxes usbmount -y
fi




if ask "Do you want to set up samba sharing?"; then
  rm -rf /etc/samba/smb.conf
  cp setup/smb.conf /etc/samba/smb.conf
  smbpasswd –a root
  if $PI; then
  smbpasswd –a pi
  fi
  if $USER; then
  smbpasswd –a $USER
  fi
  /etc/init.d/samba stop 
  /etc/init.d/samba start
fi



if ask "Install drivers for TP-Link TL-WN725N?"
  sudo wget http://raspberry-at-home.com/files/8188eu.ko -O /lib/modules/`uname -r`/kernel/drivers/net/wireless/8188eu.ko
  sudo depmod -a
  sudo modprobe 8188eu
fi


if ask "Do you want to set up wifi?"; then
  apt-get install -y  wicd-curses
  wicd-curses
fi



if ask "Install Adafruit 3.5 inch TFT drivers?"; then
  curl -SLs https://apt.adafruit.com/add | sudo bash
  sudo apt-get install raspberrypi-bootloader-adafruit-pitft
  sudo apt-get install adafruit-pitft-helper
fi



if ask "reboot now?"; then
  reboot
fi



# sudo nano /etc/network/interfaces
#
#
# auto lo
#
# iface lo inet loopback
# iface eth0 inet dhcp
#
# allow-hotplug wlan0
# auto wlan0
# iface wlan0 inet dhcp
#         wpa-ssid "your-ssid"
#         wpa-psk "your-password"
# #wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
# iface default inet dhcp
