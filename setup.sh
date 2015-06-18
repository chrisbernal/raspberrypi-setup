#!/bin/bash




# RUN FUNCTIONS
function install_bash_profile() {
  if_user_exists chris
  if_user_exists pi
}
function tplink_driver_install() {
  sudo wget https://github.com/lwfinger/rtl8188eu/raw/c83976d1dfb4793893158461430261562b3a5bf0/rtl8188eufw.bin -O /lib/firmware/rtlwifi/rtl8188eufw.bin
}
function aptget_update_upgrade() {
  sudo apt-get update -y && sudo apt-get upgrade -y
}
function aptget_dist_upgrade() {
  sudo apt-get dist-upgrade -y
}
function aptget_install_apps() {
  sudo apt-get install git ranger avahi-daemon boxes dialog htop nethogs file-roller -y
}
function adafrtuit_tft_isntall() {
  curl -SLs https://apt.adafruit.com/add | sudo bash
  sudo apt-get install raspberrypi-bootloader
  sudo apt-get install adafruit-pitft-helper
  sudo adafruit-pitft-helper -t 35r
}
function edit_network_iface() {
  sudo nano /etc/network/interfaces
}
function reboot_now() {
  sudo reboot
}




# IF USER EXISTS
function if_user_exists() {
  UserExist()
  {
     awk -F":" '{ print $1 }' /etc/passwd | grep -x $1 > /dev/null
     return $?
  }
  UserExist $1
  if [ $? = 0 ]; then
     sudo rm -rf /home/$1/.profile
     sudo git clone https://gist.github.com/e022cdfada270a414418.git /home/$1/.profile
  else
    echo '$1 user account does not exist. skipping profile install.'
  fi
}




# RUN SETUP
function RUN_SETUP() {
  echo "Run Setup"
  select setup_item in "TPLINK_DRIVER_INSTALL" "APTGET_UPDATE_UPGRADE" "APTGET_DIST_UPGRADE" "APTGET_INSTALL_APPS" "ADAFRTUIT_TFT_ISNTALL" "EDIT_NETWORK_IFACE" "REBOOT_NOW" "EXIT"
  do
  case $setup_item in
      TPLINK_DRIVER_INSTALL )   tplink_driver_install;;
      APTGET_UPDATE_UPGRADE )   aptget_update_upgrade;;
      APTGET_DIST_UPGRADE )     aptget_dist_upgrade;;
      APTGET_INSTALL_APPS )     aptget_install_apps;;
      ADAFRTUIT_TFT_ISNTALL )   adafrtuit_tft_isntall;;
      EDIT_NETWORK_IFACE )      edit_network_iface;;
      REBOOT_NOW )              reboot_now;;
      EXIT )                    exit;;
  esac
  done
}


RUN_SETUP
echo 'setup finished'
