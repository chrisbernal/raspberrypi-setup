#!/bin/bash


source ~/setup/ask.sh
source ~/setup/functions.sh

if ask "install zsh?" Y; then
zshsetup
fi

if ask "install raspi-config?" N; then
raspiconfig
fi

if ask "install tplink drivers?" Y; then
tplink
fi

if ask "update?" Y; then
update
fi

if ask "upgrade?" Y; then
upgrade
fi

if ask "dist-upgrade?" N; then
distupgrade
fi

if ask "install apps?" Y; then
aptget
fi

if ask "install adafruit tft?" N; then
tft
fi

if ask "reboot now?" N; then
reboot
fi