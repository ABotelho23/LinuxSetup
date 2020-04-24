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
sudo apt remove gnome-software-plugin-snap -y

#cleanup packages
sudo apt autoremove -y

#Remove Ubuntu dock
sudo rm -R /usr/share/gnome-shell/extensions/desktop-icons@csoriano
sudo rm -R /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com
rm -R ~/.local/share/gnome-shell/extensions/desktop-icons@csoriano
rm -R ~/.local/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com

#Install other Gnome extensions
sudo apt install bash curl dbus perl -y
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer
./gnome-shell-extension-installer 307 3.36 #Dash to Dock
./gnome-shell-extension-installer 750 3.36 #OpenWeather
./gnome-shell-extension-installer 1036 3.34 #Extensions
./gnome-shell-extension-installer 19 3.36 #User Themes
./gnome-shell-extension-installer 1228 3.36 #Arc Menu

sudo cp -R /usr/share/gnome-shell/extensions/* /home/$SUDO_USER/.local/share/gnome-shell/extensions/

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
