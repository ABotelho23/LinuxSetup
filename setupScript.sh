#!/bin/bash
echo "This script will update your system."
echo "This script will install a large amount of software."
echo "This script will only remove Dolphin, Konsole, Kate, Gwenview, S and K3b."
echo "This script assumes you selected minimal install option. This script might break things if your install isn't minimal"
echo "I recommend running this script from /tmp. That will ensure this script and its downloads get wiped after reboot."

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

read -r -p "Install Nvidia graphics driver? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
NVIDIA="yes"
else
NVIDIA="no"
fi

read -r -p "Set GTK apps scale to 2.0 for your user? " gtkscaleset
if [[ "$gtkscaleset" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
mkdir -p $HOME/.config/plasma-workspace/env/
touch $HOME/.config/plasma-workspace/env/gtkScale.sh
echo 'export GDK_SCALE=2' >> $HOME/.config/plasma-workspace/env/gtkScale.sh
echo 'export GDK_DPI_SCALE=0.5' >> $HOME/.config/plasma-workspace/env/gtkScale.sh
fi

#autosign
read -r -p "Auto-sign DKMS modules that are installed by this script? " autosign

echo "Starting script! Please do not stop this script once it has started."

#enable 32-bit
sudo dpkg --add-architecture i386

#important installs first
sudo apt-get install nemo -y
sudo apt-get install tilix -y

#removals
sudo apt-get remove dolphin konsole kate k3b gwenview skanlite -y
sudo apt autoremove -y #clean up after removals

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

#installs
sudo apt-get install asunder audacity deluge gnome-disk-utility gparted -y
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
sudo usermod -a -G kvm $USER
sudo apt-get install mosh -y

#new ppa/repo adds
sudo add-apt-repository ppa:haraldhv/shotcut -y #shotcut
sudo add-apt-repository ppa:gezakovacs/ppa -y #unetbootin
sudo add-apt-repository ppa:nilarimogard/webupd8 -y #woeusb
sudo add-apt-repository ppa:notepadqq-team/notepadqq -y #notepadqq
sudo add-apt-repository ppa:unit193/encryption -y #veracrypt
sudo add-apt-repository ppa:wireguard/wireguard -y #wireguard
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
sudo apt-add-repository ppa:maarten-fonville/android-studio -y
sudo add-apt-repository ppa:noobslab/icons -y #for pop icons
sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y #more recent GIMP versions
sudo add-apt-repository ppa:ricotz/docky -y #Plank with zoom

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - #google pub key
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' #google chrome repo

# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb

#Signal messenger
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal.list

#VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --a /etc/apt/sources.list.d/vscodium.list

#update after repo adds
sudo apt-get update

#new ppa/repo installs
sudo apt-get install shotcut -y
sudo apt-get install unetbootin -y
sudo apt-get install woeusb -y
sudo apt-get install notepadqq -y
sudo apt-get install wireguard -y
sudo apt-get install grub-customizer -y
sudo apt-get install android-studio -y
sudo apt-get install google-chrome-stable -y
sudo apt-get install system76-pop-icon-theme -y
sudo apt-get install powershell -y
sudo apt-get install gimp -y
sudo apt-get install vscodium -y
sudo apt-get install plank -y
sudo apt-get install signal-desktop -y

#signal takes some tweaking in KDE
echo '[Desktop Entry]
Name=Signal
Comment=Private messaging from your desktop
Exec=env XDG_CURRENT_DESKTOP=Unity signal-desktop %U --start-in-tray
Terminal=false
Type=Application
Icon=signal-desktop
StartupWMClass=Signal
Categories=Network;' | sudo tee /usr/share/applications/signal-desktop.desktop

mkdir $HOME/.config/autostart
touch $HOME/.config/autostart/signal-desktop.desktop
echo '[Desktop Entry]
Name=Signal
Comment=Private messaging from your desktop
Exec=env XDG_CURRENT_DESKTOP=Unity signal-desktop %U --start-in-tray
Terminal=false
Type=Application
Icon=signal-desktop
StartupWMClass=Signal
Categories=Network;' > $HOME/.config/autostart/signal-desktop.desktop #enable signal autostart

#snap installs, bad
#sudo snap install bitwarden #need to find proper deb repo, look into AppImage?

#gdebi/wget installs
mkdir deb

#skype
wget --show-progress "https://go.skype.com/skypeforlinux-64.deb" -O ./deb/skype.deb
sudo gdebi ./deb/skype.deb -n

#discord
wget --show-progress "https://discordapp.com/api/download?platform=linux&format=deb" -O ./deb/discord.deb
sudo gdebi ./deb/discord.deb -n

#android messages
wget --show-progress "https://github.com/chrisknepper/android-messages-desktop/releases/download/v1.0.1/android-messages-desktop_1.0.1_amd64.deb" -O ./deb/androidmessages.deb
sudo gdebi ./deb/androidmessages.deb -n

#brother drivers from brother.com
wget --showprogress "https://download.brother.com/welcome/dlf005893/hl2270dwlpr-2.1.0-1.i386.deb" -O ./deb/brotherlpr.deb
sudo gdebi ./deb/brotherlpr.deb -n
wget --show-progress "https://download.brother.com/welcome/dlf005895/cupswrapperHL2270DW-2.0.4-2.i386.deb" -O ./deb/brothercups.deb
sudo gdebi ./deb/brothercups.deb -n

#Slack
wget --show-progress "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.4.0-amd64.deb" -O ./deb/slack.deb
sudo gdebi ./deb/slack.deb -n

#Flutter SDK
wget --show-progress "https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.5.4-hotfix.2-stable.tar.xz" -O ./deb/fluttersdk.tar.xz
tar xf fluttersdk.tar.xz
sudo cp -R ./flutter /opt
export PATH="$PATH:/opt/flutter/bin"
echo 'export PATH="$PATH":/opt/flutter/bin' >> ~/.bashrc
flutter precache

#check if installs insync
if [ $INSYNC = "yes" ]; then
    echo "Insync install selected. Installing."
    wget --show-progress "https://d2t3ff60b2tol4.cloudfront.net/builds/insync_1.5.7.37371-artful_amd64.deb" -O ./deb/insync.deb
    sudo gdebi ./deb/insync.deb -n
    sudo apt-get update
    sudo apt-get install insync-nemo -y
else
	echo "Insync install not selected. Skipping..."
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
	git clone git://github.com/ckb-next/ckb-next.git
	sudo chmod -R 777 ckb-next/
    cd ckb-next/
    sudo ./quickinstall
    cd ..
else
	echo "CKB-next install not selected. Continuing..."
fi

if [ $CKB = "yes" ]; then
    echo "Nvidia graphics driver install selected. Installing."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt-get update
    sudo apt-get install nvidia-driver-410 -y
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

#fix shitty libinput by replacing it...
#sudo apt-get install xserver-xorg-input-synaptics -y

#fix time
timedatectl set-local-rtc 1

#fix open in terminal for tilix
gsettings set org.gnome.desktop.default-applications.terminal exec tilix

#KDE Pop theme 1
git clone git://github.com/Nequo/Pop-plasma-theme.git
sudo mkdir /usr/share/aurorae
sudo mkdir /usr/share/aurorae/themes
sudo cp -R ./Pop-plasma-theme/aurorae/Pop /usr/share/aurorae/themes/
sudo cp ./Pop-plasma-theme/color-scheme/Pop_Dark.colors /usr/share/color-schemes/

#KDE Pop theme 2
git clone git://github.com/trgeiger/pop-kde.git
sudo cp -R ./pop-kde/plasma/desktoptheme/Pop /usr/share/plasma/desktoptheme/
sudo cp ./pop-kde/color-schemes/Pop.colors /usr/share/color-schemes/
sudo cp -R ./pop-kde/Kvantum/Pop /usr/share/Kvantum/

#KDE Pop theme 3
sudo cp Pop_Dark.colors /usr/share/color-schemes/

#pop compiled for Gnome
sudo apt install libtool pkg-config sassc inkscape optipng parallel libglib2.0-dev libgdk-pixbuf2.0-dev librsvg2-dev libxml2-utils -y
git clone https://github.com/pop-os/gtk-theme.git
cd gtk-theme
make clean
make
sudo make install
cd ..

#Plan themes
git clone git://github.com/erikdubois/plankthemes.git
sudo cp -r ./plankthemes/* /usr/share/plank/themes
sudo rm -r /usr/share/plank/themes/setup-git-v1.sh
sudo rm -r /usr/share/plank/themes/git-v1.sh
sudo rm -r /usr/share/plank/themes/README.md

#more Plank themes
git clone git://github.com/LinxGem33/Plank-Themes.git
sudo cp -r ./Plank-Themes/'Plank Themes'/* /usr/share/plank/themes

#wireshark install near the end cause graphical
sudo apt-get install wireshark -y
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER

#tilix fix
echo 'if [[ $TILIX_ID ]]; then' >> $HOME/.bashrc
echo 'source /etc/profile.d/vte.sh' >> $HOME/.bashrc
echo 'fi' >> $HOME/.bashrc
ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

if [[ "$autosign" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
#ensure openssl is installed
sudo apt-get install openssl -y

#create keys
sudo openssl req -new -x509 -newkey rsa:2048 -keyout /root/MOK.priv -outform DER -out /root/MOK.der -nodes -days 36500 -subj "/CN=Descriptive common name/"

#sign modules
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n vboxdrv)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n vboxnetadp)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n vboxnetflt)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n vboxpci)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der $(modinfo -n wireguard)

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
tail $(modinfo -n vboxdrv) | grep "Module signature appended"
tail $(modinfo -n vboxnetadp) | grep "Module signature appended"
tail $(modinfo -n vboxnetflt) | grep "Module signature appended"
tail $(modinfo -n vboxpci) | grep "Module signature appended"
tail $(modinfo -n wireguard) | grep "Module signature appended"

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

sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/virtualbox.conf
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/wireguard.conf

if [ $OPENRAZER = "yes" ]; then
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/openrazer-driver.conf
fi

if [ $NVIDIA = "yes" ]; then
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/nvidia.conf
fi

fi

#clean up
sudo apt autoremove && sudo apt clean
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
