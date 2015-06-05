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




# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Set up a new user?"; then
  echo "please enter a username"
  read USER
  echo "adding new user"
  adduser $USER
  echo "adding new user to sudoers"
  adduser $USER sudo
  echo "deleting old .profile"
  rm -r -f /home/$USER/.profile
  echo "symlinking new .profile"
  ln -s -f setup/.profile /home/$USER/
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Add .profile for user 'pi'?"; then
  PI = true
  rm -r -f /home/pi/.profile
  ln -s -f setup/.profile /home/pi/
  echo "reloading bash profile"
  . /home/pi/.profile
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Run raspi-config?"; then
  echo "running raspi-config"
  raspi-config
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Run apt-get update and apt-get upgrade?"; then
  echo "updating"
  apt-get update -y && apt-get upgrade -y
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "install utils?"; then
echo "installing utils"
apt-get install samba samba-common-bin git screen avahi-daemon screen tmux curl ranger dialog htop boxes usbmount -y
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "update rpi?"; then
echo "updating rpi"
rpi-update
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Do you want to set up samba sharing?"; then
  rm -rf /etc/samba/smb.conf
  cp setup/smb.conf /etc/samba/smb.conf
  echo "adding users to samba share"
  smbpasswd –a root
  if $PI; then
  smbpasswd –a pi
  fi
  if $USER; then
  smbpasswd –a $USER
  fi
  echo "restarting samba"
  /etc/init.d/samba stop 
  /etc/init.d/samba start
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "Do you want to set up wifi with wicd-curses?"; then
apt-get install -y  wicd-curses
echo "setting up wifi"
echo "---------------"
echo "use the up and down arrow keys to navigate to your preferred network"
echo "then use the right arrow to config, enter the password and enable auto connect"
echo "then press q to quit"
wicd-curses
fi



# -----------------------------------------------------------------------------
# xxxxxxxxxxxxx
# -----------------------------------------------------------------------------
if ask "reboot now?"; then
  echo "rebooting"
  reboot
fi
