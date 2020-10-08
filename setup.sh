#!/bin/bash
echo "This script will update your system."
echo "This script will install a large amount of software."
echo "This script will only remove a handful of applications."
echo "Please remove linuxsetup folder once script2.sh has finished running."

#prompt
read -r -p "Are you sure you want to run this script? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then

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
sudo apt-get install tilix audacity gnome-disk-utility gnome-system-monitor net-tools -y
sudo apt-get install gdebi inkscape gcc make nextcloud-desktop nautilus-nextcloud perl python3 psensor okular wireguard -y
sudo apt-get install vlc nomacs thunderbird ^fonts-roboto- p7zip-full -y
sudo apt-get install openjdk-11-jdk openjdk-11-jre neofetch curl cifs-utils lame -y
sudo apt-get install ffmpeg exfat-utils openssh-server ffmpegthumbnailer -y
sudo apt-get install system-config-printer gnome-calculator gnome-screenshot hunspell-en-ca fonts-noto-color-emoji -y
sudo apt-get install seahorse apt-transport-https gimp gnome-tweaks software-properties-common -y
sudo apt-get install gnome-shell-extension-no-annoyance gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers -y
sudo apt-get install network-manager-openvpn-gnome network-manager-openconnect-gnome network-manager-l2tp-gnome network-manager-iodine-gnome -y
sudo usermod -a -G kvm $SUDO_USER

#new ppa/repo adds
sudo add-apt-repository ppa:unit193/encryption -y #veracrypt
sudo add-apt-repository ppa:papirus/papirus -y #papirus icons
sudo add-apt-repository ppa:tista/plata-theme -y #plata theme
sudo add-apt-repository ppa:andreasbutti/xournalpp-master -y #Xournal++
sudo add-apt-repository ppa:appimagelauncher-team/stable -y #AppImageLauncher

#OnlyOffice
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
echo "deb https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

#Signal messenger
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal.list

#update after repo adds
sudo apt-get update

#new ppa/repo installs
sudo apt-get install onlyoffice-desktopeditors -y
sudo apt-get install papirus-icon-theme -y
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

#Bitwarden
wget --show-progress "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -O ./deb/bitwarden.appimage
chmod +x ./deb/bitwarden.appimage
sudo mkdir /opt/bitwarden
sudo cp ./deb/bitwarden.appimage /opt/bitwarden/bitwarden.appimage

#install Roboto mono
sudo mkdir /usr/share/fonts/robotomono
sudo cp -R ./RobotoMono/* /usr/share/fonts/robotomono

#fix time
timedatectl set-local-rtc 1

#fix open in terminal for tilix
tilix &
killall tilix
gsettings set org.gnome.desktop.default-applications.terminal exec tilix

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
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 750 3.36 #OpenWeather
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 1036 3.34 #Extensions
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 19 3.36 #User Themes
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 1218 3.36 #Printers
sudo -u "$SUDO_USER" ./gnome-shell-extension-installer 1128 3.22 #Hide Activities

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
