#enable 32-bit
sudo dpkg --add-architecture i386

#Cinnamon stable PPA
sudo add-apt-repository ppa:embrosyn/cinnamon -y

#do updates and software upgrades
sudo apt-get update
sudo apt-get upgrade -y

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

sudo apt-get install tilix -y

#Remove and replace cloud-init
sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/51-netcfg.yaml
sudo apt-get remove cloud-init -y
sudo rm /etc/profile.d/Z99-cloudinit-warning.sh
sudo rm /etc/profile.d/Z99-cloud-locale-test.sh
sudo rm /etc/profile.d/Z97-byobu.sh

#prompt
read -r -p "COMPLETE! REBOOT NOW? [y/N] " rebootnow
if [[ "$rebootnow" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
echo "Rebooting!"
sudo reboot
else
echo "Reboot not selected. Please ensure you reboot at a later time."
fi
