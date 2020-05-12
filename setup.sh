#!/bin/bash
echo "This script will update your system."
echo "This script will install a large amount of software."
echo "This script will only remove a handful of applications."
echo "Please remove LinuxSetup folder once setup.sh has finished running."

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

read -r -p "Install Android Studio and Flutter SDK? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
ASTUDIO="yes"
else
ASTUDIO="no"
fi

read -r -p "Install Nvidia graphics driver? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
NVIDIA="yes"
else
NVIDIA="no"
fi

#autosign
read -r -p "Auto-sign DKMS modules that are installed by this script? " autosign

echo "Starting script! Please do not stop this script once it has started."

#disable auto updates/upgrades check
systemctl disable --now apt-daily{,-upgrade}.{timer,service}
sudo killall dpkg

#enable 32-bit
sudo dpkg --add-architecture i386

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

#removals
sudo apt-get install tilix -y
sudo apt-get remove byobu gnome-terminal evince eog geary -y
sudo apt autoremove -y #clean up after removals


#installs
sudo apt-get install tilix asunder audacity deluge gnome-disk-utility gnome-system-monitor net-tools -y
sudo apt-get install gdebi inkscape libreoffice gcc make perl python3 psensor okular wireguard -y
sudo apt-get install vlc nomacs gnome-boxes thunderbird ^fonts-roboto- wine-stable p7zip-full traceroute -y
sudo apt-get install openjdk-11-jdk openjdk-11-jre neofetch curl cifs-utils lame -y
sudo apt-get install ffmpeg cups adb fastboot exfat-utils openssh-server blender avahi-discover ffmpegthumbnailer -y
sudo apt-get install easytag mosh nut system-config-printer gnome-calculator gnome-screenshot hunspell-en-ca fonts-noto-color-emoji -y
sudo apt-get install seahorse qemu-kvm apt-transport-https grub-customizer gimp gnome-tweaks software-properties-common -y
sudo apt-get install network-manager-openvpn-gnome network-manager-openconnect-gnome network-manager-l2tp-gnome network-manager-iodine-gnome -y
sudo usermod -a -G kvm $SUDO_USER

#new ppa/repo adds
sudo add-apt-repository ppa:nilarimogard/webupd8 -y #woeusb
sudo add-apt-repository ppa:unit193/encryption -y #veracrypt
sudo add-apt-repository ppa:papirus/papirus -y #papirus icons
sudo add-apt-repository ppa:tista/plata-theme -y #plata theme
sudo add-apt-repository ppa:andreasbutti/xournalpp-master -y #Xournal++
sudo add-apt-repository ppa:appimagelauncher-team/stable -y #AppImageLauncher

#Signal messenger
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal.list

#VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee -a /etc/apt/sources.list.d/vscodium.list

#update after repo adds
sudo apt-get update

#new ppa/repo installs
sudo apt-get install woeusb -y
sudo apt-get install papirus-icon-theme
sudo apt-get install codium -y
sudo apt-get install veracrypt -y
sudo apt-get install signal-desktop -y
sudo apt-get install plata-theme -y
sudo apt-get install xournalpp -y
sudo apt-get install appimagelauncher -y

signal takes some tweaking
echo '[Desktop Entry]
Name=Signal
Comment=Private messaging from your desktop
signal-desktop %U --start-in-tray
Terminal=false
Type=Application
Icon=signal-desktop
StartupWMClass=Signal
Categories=Network;' | sudo tee /usr/share/applications/signal-desktop.desktop

mkdir /home/$SUDO_USER/.config/autostart
sudo chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config
cp /usr/share/applications/signal-desktop.desktop /home/$SUDO_USER/.config/autostart/signal-desktop.desktop #enable signal autostart

#gdebi/wget installs
mkdir deb

#discord
wget --show-progress "https://discordapp.com/api/download?platform=linux&format=deb" -O ./deb/discord.deb
sudo gdebi ./deb/discord.deb -n

#android messages
wget --show-progress "https://github.com/chrisknepper/android-messages-desktop/releases/download/v3.1.0/android-messages-desktop_3.1.0_amd64.deb" -O ./deb/androidmessages.deb
sudo gdebi ./deb/androidmessages.deb -n

#Bitwarden
wget --show-progress "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -O ./deb/bitwarden.appimage
chmod +x ./deb/bitwarden.appimage
sudo mkdir /opt/bitwarden
sudo cp ./deb/bitwarden.appimage /opt/bitwarden/bitwarden.appimage

#check if installs insync
if [ $INSYNC = "yes" ]; then
    echo "Insync install selected. Installing."
    wget --show-progress "https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.1.4.40797-bionic_amd64.deb" -O ./deb/insync.deb
    sudo gdebi ./deb/insync.deb -n
    sudo apt-get update
    sudo apt-get install insync-nautilus -y
else
	echo "Insync install not selected. Skipping..."
fi

#check if installs openrazer
if [ $OPENRAZER = "yes" ]; then
    echo "OpenRazer install selected. Installing."
    sudo add-apt-repository ppa:openrazer/stable -y
    sudo add-apt-repository ppa:polychromatic/stable -y
    sudo apt-get update
    sudo apt install openrazer-meta -y
    sudo apt install polychromatic -y
    sudo gpasswd -a $SUDO_USER plugdev
    sudo gpasswd -a $USER plugdev
else
	echo "Openrazer/Polychromatic install not selected. Skipping..."
fi

if [ $CKB = "yes" ]; then
    echo "CKB-next install selected. Installing."
    sudo add-apt-repository ppa:tatokis/ckb-next -y
    sudo apt install ckb-next -y
else
	echo "CKB-next install not selected. Continuing..."
fi

#check if installs Android Studio and Flutter SDK
if [ $ASTUDIO = "yes" ]; then
	sudo apt-add-repository ppa:maarten-fonville/android-studio -y #android studio
	sudo apt-get install android-studio -y
	#Flutter SDK
	wget --show-progress "https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.9-stable.tar.xz" -O ./deb/fluttersdk.tar.xz
	tar xf ./deb/fluttersdk.tar.xz
	sudo cp -R ./flutter /opt
	export PATH="$PATH:/opt/flutter/bin"
	echo 'export PATH="$PATH":/opt/flutter/bin' >> ~/.bashrc
	flutter precache
else
	echo "Android Studio and Flutter SDK install not selected. Skipping..."
fi

if [ $NVIDIA = "yes" ]; then
    echo "Nvidia graphics driver install selected. Installing."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt-get update
    sudo apt nvidia-graphics-drivers-440 -y
else
	echo "Nvidia graphics driver install not selected. Skipping..."
fi

#setup Hangouts and Google Keep
sudo cp -R ./DesktopFiles/* /usr/share/applications
sudo cp -R ./icons/* /usr/share/icons
sudo rm /usr/share/applications/android-messages-desktop.desktop

#install Roboto mono
sudo mkdir /usr/share/fonts/robotomono
sudo cp -R ./RobotoMono/* /usr/share/fonts/robotomono

#fix time
timedatectl set-local-rtc 1

#fix open in terminal for tilix
tilix &
killall tilix
gsettings set org.gnome.desktop.default-applications.terminal exec tilix

#wireshark install near the end cause graphical
sudo apt-get install wireshark -y
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $SUDO_USER

#MS fonts
sudo apt-get install ttf-mscorefonts-installer -y
sudo fc-cache -f -v

#tilix fix
echo 'if [[ $TILIX_ID ]]; then' >> /home/$SUDO_USER/.bashrc
echo 'source /etc/profile.d/vte.sh' >> /home/$SUDO_USER/.bashrc
echo 'fi' >> /home/$SUDO_USER/.bashrc
ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

#neofetch at terminal start
echo 'neofetch' >> /home/$SUDO_USER/.bashrc

#purple background fix
sudo update-alternatives --install /usr/share/gnome-shell/gdm3-theme.gresource gdm3-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource 100

#Remove Ubuntu dock
sudo rm -R /usr/share/gnome-shell/extensions/desktop-icons@csoriano
sudo rm -R /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com
rm -R /home/$SUDO_USER/.local/share/gnome-shell/extensions/desktop-icons@csoriano
rm -R /home/$SUDO_USER/.local/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com

#Install other Gnome extensions
sudo apt install bash curl dbus perl -y
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 307 3.36 #Dash to Dock
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 19 3.36 #User Themes
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 1218 3.36 #Printers
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 7 3.36 #Removable Drive
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 8 3.36 #Places

sudo apt install gnome-shell-extension-log-out-button gnome-shell-extension-weather gnome-shell-extension-prefs gnome-shell-extension-multi-monitors gnome-shell-extension-no-annoyance gnome-shell-extension-hide-activities gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers gnome-shell-extension-appindicator gnome-shell-extension-caffeine -y

#testing this
sudo mv /home/$SUDO_USER/.local/share/gnome-shell/extentions/* /usr/share/gnome-shell/extensions/
sudo chmod 755 /usr/share/gnome-shell/extensions/*

if [[ "$autosign" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
#ensure openssl is installed
sudo apt-get install openssl -y

#create keys
sudo openssl req -new -x509 -newkey rsa:2048 -keyout /root/MOK.priv -outform DER -out /root/MOK.der -nodes -days 36500 -subj "/CN=Descriptive common name/"

#sign modules
if [ $OPENRAZER = "yes" ]; then
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razerkbd)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razermouse)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razermousemat)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razerkraken)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razermug)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n razercore)
fi

if [ $NVIDIA = "yes" ]; then
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n nvidia)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n nvidia-modeset)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n nvidia-drm)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n nvidia-uvm)
fi

#check modules are signed
if [ $OPENRAZER = "yes" ]; then
tail $(modinfo -n razerkbd) | grep "Module signature appended"
tail $(modinfo -n razermouse) | grep "Module signature appended"
tail $(modinfo -n razermousemat) | grep "Module signature appended"
tail $(modinfo -n razerkraken) | grep "Module signature appended"
tail $(modinfo -n razermug) | grep "Module signature appended"
tail $(modinfo -n razercore) | grep "Module signature appended"
fi

if [ $NVIDIA = "yes" ]; then
tail $(modinfo -n nvidia) | grep "Module signature appended"
tail $(modinfo -n nvidia-modeset) | grep "Module signature appended"
tail $(modinfo -n nvidia-drm) | grep "Module signature appended"
tail $(modinfo -n nvidia-uvm) | grep "Module signature appended"
fi

#enroll the key
sudo mokutil --import /root/MOK.der

#confirm key is enrolled
mokutil --test-key /root/MOK.der

#auto re-sign: create generic conf file
echo 'POST_BUILD=../../../../../../root/sign-kernel.sh' | sudo tee -a /etc/dkms/sign-kernel-objects.conf

echo '#!/bin/bash

cd ../$kernelver/$arch/module/

for kernel_object in *ko; do
     echo "Signing kernel_object: $kernel_object"
    /usr/src/linux-headers-$kernelver/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der "$kernel_object";
    mokutil --import /root/MOK.der
done' | sudo tee -a /root/sign-kernel.sh
sudo chmod +x /root/sign-kernel.sh

if [ $OPENRAZER = "yes" ]; then
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/openrazer-driver.conf
fi

if [ $NVIDIA = "yes" ]; then
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/nvidia.conf
fi

fi

#clean up
#Remove SNAPS!
sudo apt remove --purge snapd -y

#Disable pppd-dns service
sudo systemctl disable pppd-dns.service

# Re-add Gnome store, remove snap plugin
sudo apt install gnome-software -y
sudo apt remove gnome-software-plugin-snap -y
sudo apt remove --purge snapd -y
sudo apt-mark hold snap

#cleanup packages
sudo apt autoremove -y

if [[ "$autosign" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
echo "See https://sourceware.org/systemtap/wiki/SecureBoot for enrolling MOK keys that were generated by this script."
fi
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
