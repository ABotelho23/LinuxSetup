#!/bin/bash
echo "This script installs and set up the Cinnamon Desktop Environment as well as MDM and Slick greeter."
read -r -p "Are you sure you want to run this script? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then

systemctl disable --now apt-daily{,-upgrade}.{timer,service}
sudo killall dpkg

#updates
sudo apt-get update
sudo apt-get upgrade -y

#Cinnamon stable PPA
sudo add-apt-repository ppa:embrosyn/cinnamon -y
sudo apt-get update

#Cinnamon core
sudo apt-get install cinnamon-core slick-greeter lightdm-settings blueberry plymouth -y

#Remove and replace cloud-init
sudo rm /etc/netplan/*

#managed by NetworkManager
echo 'network:
  version: 2
  renderer: NetworkManager' | sudo tee /etc/netplan/51-netcfg.yaml

sudo apt-get remove cloud-init -y
sudo rm /etc/profile.d/Z99-cloudinit-warning.sh
sudo rm /etc/profile.d/Z99-cloud-locale-test.sh
sudo rm /etc/profile.d/Z97-byobu.sh

#Remove Ubuntu Server stuff
sudo apt-get remove ubuntu-server modemmanager lxd lxcfs grub-legacy-ec2 cloud-guest-utils cloud-initramfs-* landscape-common ubuntu-advantage-tools unattended-upgrades networkd-dispatcher -y
sudo apt remove --purge snapd -y
sudo systemctl disable pppd-dns.service

echo 'GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""' > /etc/default/grub #enable quiet splash
sudo update-grub

sudo apt-get install plymouth-themes -y
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/spinfinity/spinfinity.plymouth 100
sudo update-initramfs -u

sudo apt autoremove -y

echo "Please ensure to run script2.sh upon reboot."

#prompt
read -r -p "Cinnamon installation COMPLETE! REBOOT NOW? [y/N] " rebootnow
if [[ "$rebootnow" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
echo "Rebooting!"
sudo reboot
else
echo "Reboot not selected. Please ensure you reboot at a later time."
fi

else
  echo "Ok, exiting..."
fi