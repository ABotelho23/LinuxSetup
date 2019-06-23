#!/bin/bash
echo "This script will update your system."
echo "This script will install a large amount of software."
echo "This script will only remove a handful of applications."
echo "This script assumes you selected minimal install option. This script might break things if your install isn't minimal"
echo "I recommend running this script from /tmp. That will ensure this script and its downloads get wiped after reboot."

#prompt
read -r -p "Are you sure you want to run this script? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then

echo "Starting script! Please do not stop this script once it has started."

#enable 32-bit
sudo dpkg --add-architecture i386

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

#Cinnamon stable PPA
sudo add-apt-repository ppa:embrosyn/cinnamon -y
sudo apt-get update

#Cinnamon Core
sudo apt-get install cinnamon-core lightdm slick-greeter blueberry -y

#Remove old greeter config files
sudo rm /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
sudo rm /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf

#Add new greeter config file
touch /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf
echo '[SeatDefaults]
greeter-session=slick-greeter
user-session=cinnamon' > /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf

#removals
sudo apt-get remove byobu gnome-terminal -y
sudo apt autoremove -y #clean up after removals

#installs
sudo apt-get install tilix -y
sudo apt-get install asunder audacity deluge gnome-disk-utility gnome-system-monitor gparted -y
sudo apt-get install gdebi -y
sudo apt-get install inkscape -y
sudo apt-get install libreoffice -y
sudo apt-get install gcc -y
sudo apt-get install make -y
sudo apt-get install perl -y
sudo apt-get install python3 -y
sudo apt-get install psensor -y
sudo apt-get install nitrogen -y
sudo apt-get install okular -y
sudo apt-get install vlc -y
sudo apt-get install xdiagnose -y
sudo apt-get install simple-scan -y
sudo apt-get install nomacs -y
sudo apt-get install virtualbox -y
sudo apt-get install thunderbird -y
sudo apt-get install fonts-roboto* -y
sudo apt-get install wine-stable -y
sudo apt-get install p7zip-full -y
sudo apt-get install traceroute -y
sudo apt-get install net-tools -y
sudo apt-get install putty -y
sudo apt-get install openjdk-11-jdk -y
sudo apt-get install openjdk-11-jre -y
sudo apt-get install network-manager* -y
sudo apt-get install redshift -y
sudo apt-get install neofetch -y
sudo apt-get install curl -y
sudo apt-get install cifs-utils -y
sudo apt-get install alacarte -y
sudo apt-get install git -y
sudo apt-get install openvpn -y
sudo apt-get install lame -y
sudo apt-get install ffmpeg -y
sudo apt-get install cups -y
sudo apt-get install adb -y
sudo apt-get install fastboot -y
sudo apt-get install exfat-fuse exfat-utils -y
sudo apt-get install openssh-server -y
sudo apt-get install blender -y
sudo apt-get install avahi-discover -y
sudo apt-get install ffmpegthumbnailer -y
sudo apt-get install easytag -y
sudo apt-get install brother-* -y
sudo apt-get install qemu-kvm -y
sudo usermod -a -G kvm $SUDO_USER
sudo apt-get install mosh -y

#tilix fix
echo 'if [[ $TILIX_ID ]]; then' >> /home/$SUDO_USER/.bashrc
echo 'source /etc/profile.d/vte.sh' >> /home/$SUDO_USER/.bashrc
echo 'fi' >> /home/$SUDO_USER/.bashrc
ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

#neofetch at terminal start
echo 'neofetch' >> /home/$SUDO_USER/.bashrc

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

#clean up
sudo apt autoremove && sudo apt clean

#prompt
read -r -p "COMPLETE! REBOOT NOW? [y/N] " rebootnow
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
