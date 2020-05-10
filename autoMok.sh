#!/bin/bash

#create generic conf file
sudo echo 'POST_BUILD=../../../../../../root/sign-kernel.sh' >> /etc/dkms/sign-kernel-objects.conf

sudo echo '#!/bin/bash

cd ../$kernelver/$arch/module/

for kernel_object in *ko; do
     echo "Signing kernel_object: $kernel_object"
    /usr/src/linux-headers-$kernelver/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der "$kernel_object";
done' >> /root/sign-kernel.sh

sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/virtualbox.conf
sudo ln -s /etc/dkms/sign-kernel-objects.conf /etc/dkms/wireguard.conf
