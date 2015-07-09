#!/bin/bash

function zshsetup() {
  sudo apt-get update -y
  sudo apt-get install zsh -y
  chsh -s $(which zsh)
}

function raspiconfig() {
  wget http://archive.raspberrypi.org/debian/pool/main/r/raspi-config/raspi-config_20121028_all.deb
  wget http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/l/lua5.1/lua5.1_5.1.5-4_armel.deb
  wget http://http.us.debian.org/debian/pool/main/t/triggerhappy/triggerhappy_0.3.4-2_armel.deb
  dpkg -i triggerhappy_0.3.4-2_armel.deb
  dpkg -i lua5.1_5.1.5-4_armel.deb
  dpkg -i raspi-config_20121028_all.deb
}

function tplink() {
  sudo wget https://github.com/lwfinger/rtl8188eu/raw/c83976d1dfb4793893158461430261562b3a5bf0/rtl8188eufw.bin -O /lib/firmware/rtlwifi/rtl8188eufw.bin
}

function update() {
  sudo apt-get update -y
}

function upgrade() {
  sudo apt-get upgrade -y
}

function distupgrade() {
  sudo apt-get dist-upgrade -y
}

function aptget() {
  sudo apt-get install git ranger avahi-daemon boxes dialog htop nethogs file-roller -y
}

function tft() {
  curl -SLs https://apt.adafruit.com/add | sudo bash
  sudo apt-get install raspberrypi-bootloader
  sudo apt-get install adafruit-pitft-helper
  sudo adafruit-pitft-helper -t 35r
}

function reboot() {
  sudo reboot
}