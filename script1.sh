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
sudo apt-get install cinnamon-core mdm slick-greeter blueberry -y

#Remove and replace cloud-init
sudo rm /etc/netplan/50-cloud-init.yaml

#managed by NetworkManager
echo 'network:
  version: 2
  renderer: NetworkManager' | sudo tee /etc/netplan/51-netcfg.yaml

sudo apt-get remove cloud-init -y
sudo rm /etc/profile.d/Z99-cloudinit-warning.sh
sudo rm /etc/profile.d/Z99-cloud-locale-test.sh
sudo rm /etc/profile.d/Z97-byobu.sh

#Remove Ubuntu Server stuff
sudo apt-get remove ubuntu-server lxd grub-legacy-ec2 cloud-* landscape-common -y
sudo apt remove --purge snapd -y

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