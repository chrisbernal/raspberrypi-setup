#!/bin/bash




# YES NO FUNCTION
function YESNO() {
  echo "Run $1?"
  select yn in "Yes" "No"
  case $yn in
      Yes ) $1;;
      No ) exit;;
  esac
}



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




# initialize
YESNO tplink_driver_install
YESNO aptget_update_upgrade
YESNO aptget_dist_upgrade
YESNO aptget_install_apps
YESNO adafrtuit_tft_isntall
YESNO edit_network_iface
YESNO reboot_now
echo 'setup finished'
