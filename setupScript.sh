#!/bin/bash
echo "This script will update your system."
echo "This script will install a large amount of software."
echo "This script will only remove Chromium and Nautilus."
echo "This script assumes you selected minimal install option."

#prompt
read -r -p "Are you sure you want to run this script? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then

read -r -p "Install Insync? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
INSYNC="yes"
else
INSYNC="no"
fi

read -r -p "Install Google Play Music Manager? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
MUSICMANAGER="yes"
else
MUSICMANAGER="no"
fi

read -r -p "Install OpenRazer/Polychromatic? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
OPENRAZER="yes"
else
OPENRAZER="no"
fi

read -r -p "Install CKB? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
CKB="yes"
else
CKB="no"
fi

#enable 32-bit
sudo dpkg --add-architecture i386

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

#removals
chromium-browser
nautilus

#installs
gdebi
asunder
audacity
gnome-calculator
deluge
eclipse
nemo
caffeine
gnome-disk-utility
gparted
gimp
inkscape
libreoffice
gcc
make
perl
python3
psensor
nitrogen
okular
vlc
xdiagnose
simple-scan
gnome-system-monitor
nomacs
openjdk-11-jdk
openjdk-11-jre
virtualbox
thunderbird
plank
lightdm-settings
gnome-weather
papirus-icon-theme
materia-gtk-theme
fonts-roboto*
wine-stable
p7zip-full
traceroute
net-tools
putty
default-jrk
default-jre
network-manager*
gnome-tweak-tool
gnome-tweaks
neofetch
cifs-utils
alacarte
git
openvpn
lame
ffmpeg
adb
fastboot
exfat-fuse exfat-utils
libinput-tools
openssh-server
openshot
blender

sudo apt-get install wireshark
sudo dpkg-reconfigure wireshark-common 
sudo usermod -a -G wireshark $USER

#new ppa/repo adds
#sudo add-apt-repository ppa:haraldhv/shotcut -y #shotcut #NO RELEASE FILE YET
sudo add-apt-repository ppa:notepadqq-team/notepadqq -y #notepadqq
sudo add-apt-repository ppa:unit193/encryption -y #veracrypt
sudo add-apt-repository ppa:webupd8team/atom #atom
sudo add-apt-repository ppa:wireguard/wireguard #wireguard
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
#sudo add-apt-repository ppa:gezakovacs/ppa -y #unetbootin #NO RELEASE FILE YET
#sudo add-apt-repository ppa:nilarimogard/webupd8 -y #woeusb #NO RELEASE FILE YET
sudo apt-add-repository ppa:maarten-fonville/android-studio -y
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - #google pub key
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' #google chrome repo

#update after repo adds
sudo apt-get update

#new ppa installs
shotcut
notepadqq
wireguard
grub-customizer
android-studio
google-chrome-stable
atom
apm install atom-material-ui
apm install atom-material-syntax-light
apm install atom-material-syntax
apm install language-batchfile
apm install language-powershell


#gdebi installs
teamviewer
discord
skype

#check if installs insync
if [ $INSYNC = "yes" ]; then
	sudo gdebi insync.deb -n
else
	echo "Insync install not selected. Continuing..."
fi

#check if installs google play music manager
if [ $MUSICMANAGER = "yes" ]; then
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google.list' #google play music manager repo
	sudo apt-get update
	sudo apt-get install google-musicmanager-beta
else
	echo "Google Play Music Manager install not selected. Continuing..."
fi

#check if installs openrazer
if [ $OPENRAZER = "yes" ]; then
	sudo add-apt-repository ppa:openrazer/stable -y
	sudo add-apt-repository ppa:lah7/polychromatic -y
	
	sudo apt-get update
	
	sudo apt install openrazer-meta -y
	sudo apt install polychromatic -y
	sudo gpasswd -a $USER plugdev
else
	echo "Openrazer/Polychromatic install not selected. Continuing..."
fi

if [ $CKB = "yes" ]; then
	sudo apt-get install build-essential libudev-dev qt5-default zlib1g-dev libappindicator-dev -y
	git clone https://github.com/ckb-next/ckb-next
	sudo chmod -R 777 ckb-next/
	sudo bash ./ckb-next/quickinstall
else
	echo "CKB-next install not selected. Continuing..."
fi


#fix shitty libinput by replacing it...
#sudo apt-get install xserver-xorg-input-synaptics -y

#fix time
timedatectl set-local-rtc 1

#fix open in terminal for tilix
gsettings set org.cinnamon.desktop.default-applications.terminal exec tilix

#make Nemo default FM
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

echo "Don't forget! Set your theme, set your icons, set your fonts!"

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
