#!/bin/bash
echo "This script cleans up the installation."
read -r -p "Are you sure you want to run this script? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then

#disable auto updates/upgrades check
systemctl disable --now apt-daily{,-upgrade}.{timer,service}
sudo killall dpkg

#updates
sudo apt-get update
sudo apt-get upgrade -y

#Remove SNAPS!
sudo apt remove --purge snapd -y

#Disable pppd-dns service
sudo systemctl disable pppd-dns.service

# Re-add Gnome store, remove snap plugin
sudo apt install gnome-software -y
sudo apt remove gnome-software-plugin-snap

#cleanup packages
sudo apt autoremove -y

echo "Please ensure to run script2.sh upon reboot."

#prompt
read -r -p "Initial setup COMPLETE! REBOOT NOW? [y/N] " rebootnow
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
