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

read -r -p "Install CKB-next? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
CKB="yes"
else
CKB="no"
fi

read -r -p "Install Nvidia graphics driver? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
NVIDIA="yes"
else
NVIDIA="no"
fi

echo "Starting script! Please do not stop this script once it has started."

#enable 32-bit
sudo dpkg --add-architecture i386

#removals
sudo apt-get remove chromium-browser -y
sudo apt-get remove nautilus -y

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

#installs
sudo apt-get install gdebi -y
sudo apt-get install asunder -y
sudo apt-get install audacity -y
sudo apt-get install gnome-calculator -y
sudo apt-get install deluge -y
sudo apt-get install eclipse -y
sudo apt-get install nemo -y
sudo apt-get install caffeine -y
sudo apt-get install gnome-disk-utility -y
sudo apt-get install gparted -y
sudo apt-get install gimp -y
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
sudo apt-get install gnome-system-monitor -y
sudo apt-get install nomacs -y
sudo apt-get install virtualbox -y
sudo apt-get install thunderbird -y
sudo apt-get install plank -y
sudo apt-get install lightdm-settings -y
sudo apt-get install gnome-weather -y
sudo apt-get install papirus-icon-theme -y
sudo apt-get install materia-gtk-theme -y
sudo apt-get install fonts-roboto* -y
sudo apt-get install wine-stable -y
sudo apt-get install p7zip-full -y
sudo apt-get install traceroute -y
sudo apt-get install net-tools -y
sudo apt-get install putty -y
sudo apt-get install default-jrk -y
sudo apt-get install default-jre -y
sudo apt-get install network-manager* -y
sudo apt-get install gnome-tweak-tool -y
sudo apt-get install gnome-tweaks -y
sudo apt-get install neofetch -y
sudo apt-get install cifs-utils -y
sudo apt-get install alacarte -y
sudo apt-get install git -y
sudo apt-get install openvpn -y
sudo apt-get install lame -y
sudo apt-get install ffmpeg -y
sudo apt-get install adb -y
sudo apt-get install fastboot -y
sudo apt-get install exfat-fuse exfat-utils -y
sudo apt-get install libinput-tools -y
sudo apt-get install openssh-server -y
sudo apt-get install openshot -y
sudo apt-get install blender -y

#new ppa/repo adds
#sudo add-apt-repository ppa:haraldhv/shotcut -y #shotcut #NO RELEASE FILE YET
sudo add-apt-repository ppa:notepadqq-team/notepadqq -y #notepadqq
sudo add-apt-repository ppa:unit193/encryption -y #veracrypt
sudo add-apt-repository ppa:webupd8team/atom -y #atom
sudo add-apt-repository ppa:wireguard/wireguard -y #wireguard
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
#sudo add-apt-repository ppa:gezakovacs/ppa -y #unetbootin #NO RELEASE FILE YET
#sudo add-apt-repository ppa:nilarimogard/webupd8 -y #woeusb #NO RELEASE FILE YET
sudo apt-add-repository ppa:maarten-fonville/android-studio -y
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - #google pub key
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' #google chrome repo

#update after repo adds
sudo apt-get update

#new ppa installs
#sudo apt-get install shotcut -y #NO RELEASE FILE YET
#sudo apt-get install unetbootin -y #NO RELEASE FILE YET
#sudo apt-get install woeusb -y #NO RELEASE FILE YET
sudo apt-get install notepadqq -y
sudo apt-get install wireguard -y
sudo apt-get install grub-customizer -y
sudo apt-get install android-studio -y
sudo apt-get install google-chrome-stable -y
sudo apt-get install atom -y
apm install atom-material-ui
apm install atom-material-syntax-light
apm install atom-material-syntax
apm install language-batchfile
apm install language-powershell


#gdebi installs
sudo gdebi teamviewer.deb -n
sudo gdebi discord.deb -n
sudo gdebi skype.deb -n

#check if installs insync
if [ $INSYNC = "yes" ]; then
    echo "Insync install selected. Installing."
    sudo gdebi insync.deb -n
else
	echo "Insync install not selected. Skipping..."
fi

#check if installs google play music manager
if [ $MUSICMANAGER = "yes" ]; then
    echo "Google Play Music Manager install selected. Installing."
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google.list' #google play music manager repo
	sudo apt-get update
	sudo apt-get install google-musicmanager-beta
else
	echo "Google Play Music Manager install not selected. Skipping..."
fi

#check if installs openrazer
if [ $OPENRAZER = "yes" ]; then
    echo "OpenRazer install selected. Installing."
    sudo add-apt-repository ppa:openrazer/stable -y
	sudo add-apt-repository ppa:lah7/polychromatic -y

	sudo apt-get update

	sudo apt install openrazer-meta -y
	sudo apt install polychromatic -y
	sudo gpasswd -a $USER plugdev
else
	echo "Openrazer/Polychromatic install not selected. Skipping..."
fi

if [ $CKB = "yes" ]; then
    echo "CKB-next install selected. Installing."
    sudo apt-get install build-essential cmake libudev-dev qt5-default zlib1g-dev libappindicator-dev libpulse-dev libquazip5-dev -y
	git clone https://github.com/ckb-next/ckb-next
	sudo chmod -R 777 ckb-next/
    cd ckb-next/
    sudo ./quickinstall
    cd ..
else
	echo "CKB-next install not selected. Continuing..."
fi

if [ $CKB = "yes" ]; then
    echo "Nvidia graphics driver install selected. Installing."
    sudo apt-get install nvidia-current-updates
else
	echo "Nvidia graphics driver install not selected. Skipping..."
fi

#fix shitty libinput by replacing it...
#sudo apt-get install xserver-xorg-input-synaptics -y

#fix time
timedatectl set-local-rtc 1

#fix open in terminal for tilix
gsettings set org.cinnamon.desktop.default-applications.terminal exec tilix

#make Nemo default FM
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

#wireshark install near the end cause graphical
sudo apt-get install wireshark -y
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER

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
