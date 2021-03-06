#! /bin/sh

ISO_FILE=/vagrant/ubuntu-14.04.2-server-amd64.iso
DOCKER_NODE_IMG_FILE=/vagrant/usb/goddard/images/node.img.tar
ISO_MNT=/mnt/iso
USB_MNT=/mnt/usb

# read in the device
if [ -z "$1" ]
  then 
    echo "You need to supply the device i.e. /dev/sdb"
    exit 1
  else
    USB_DEVICE=$1
    USB_PARTITION=$USB_DEVICE"1"
  fi

###
# Prepare the USB Disk
###

echo "Preparing USB Disk"

# wipe the MBR
sudo dd if=/dev/zero of=$USB_DEVICE bs=1024 count=1024

# get size
SIZE=`sudo fdisk -l $USB_DEVICE | grep Disk | awk '{print $5}'`
echo DISK SIZE - $SIZE bytes

# get cylinders
CYLINDERS=`echo $SIZE/255/63/512 | bc`

# create partition using scriptable fdisk 
{
echo ,,,*
} | sudo sfdisk -L -q -D -H 255 -S 63 -C $CYLINDERS $USB_DEVICE

# create filesystem
sudo mkdosfs $USB_PARTITION

echo "Partition Created && Filesystem Ready"

###
# Prepare installation files
###

# create the apps and images dir
sudo mkdir /vagrant/usb/goddard/apps && mkdir /vagrant/usb/goddard/images 

# get the ubuntu iso
echo "Checking for installer iso"
if [ ! -f $ISO_FILE ]; then
  wget http://releases.ubuntu.com/14.04.2/ubuntu-14.04.2-server-amd64.iso
else
  echo "Installer iso found"
fi

# get docker image
echo "Checking for docker node image"
if [ ! -f $DOCKER_NODE_IMG_FILE ]; then
	sudo docker pull iodigital/ubuntu-node-goddard:v1
  sudo docker save iodigital/ubuntu-node-goddard:v1 > $DOCKER_NODE_IMG_FILE
else
  echo "Docker node image file found"
fi

# mount the ubuntu iso
sudo mount $ISO_FILE $ISO_MNT

# mount usb
sudo mount $USB_PARTITION $USB_MNT

# copy all the files across
sudo 7z x $ISO_FILE -o$USB_MNT

# some filenames have been chopped due to a 64 char restriction - doh!
cd $USB_MNT"/pool/main"

# a fix for most by fixing .ude back to .udeb
sudo find . -name "*.ude" -exec mv {} {}b \;

# in /l/linux/
cd $USB_MNT"/pool/main/l/linux"
sudo mv ./pcmcia-storage-modules-3.13.0-45-generic-di_3.13.0-45.74_amd6.udeb ./pcmcia-storage-modules-3.13.0-45-generic-di_3.13.0-45.74_amd64.udeb

# in /l/linux-lts-utopic/
cd $USB_MNT"/pool/main/l/linux-lts-utopic"
sudo mv ./crypto-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd6.udeb ./crypto-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./firewire-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.udeb ./firewire-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./floppy-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd6.udeb ./floppy-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./fs-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd.udeb ./fs-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./fs-secondary-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04..udeb ./fs-secondary-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./linux-image-extra-3.16.0-30-generic_3.16.0-30.40~14.04.1_amd6.deb ./linux-image-extra-3.16.0-30-generic_3.16.0-30.40~14.04.1_amd64.deb
sudo mv ./message-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd.udeb ./message-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./multipath-modules-3.16.0-25-generic-di_3.16.0-25.33~14.04.2_a.udeb ./multipath-modules-3.16.0-25-generic-di_3.16.0-25.33~14.04.2_amd64.udeb
sudo mv ./multipath-modules-3.16.0-26-generic-di_3.16.0-26.35~14.04.1_a.udeb ./multipath-modules-3.16.0-26-generic-di_3.16.0-26.35~14.04.1_amd64.udeb
sudo mv ./multipath-modules-3.16.0-28-generic-di_3.16.0-28.38~14.04.1_a.udeb ./multipath-modules-3.16.0-28-generic-di_3.16.0-28.38~14.04.1_amd64.udeb
sudo mv ./multipath-modules-3.16.0-29-generic-di_3.16.0-29.39~14.04.1_a.udeb ./multipath-modules-3.16.0-29-generic-di_3.16.0-29.39~14.04.1_amd64.udeb
sudo mv ./multipath-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_a.udeb ./multipath-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./nic-pcmcia-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_.udeb ./nic-pcmcia-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./nic-shared-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_.udeb ./nic-shared-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./nic-usb-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd.udeb ./nic-usb-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./parport-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd.udeb ./parport-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./pcmcia-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd6.udeb ./pcmcia-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./pcmcia-storage-modules-3.16.0-30-generic-di_3.16.0-30.40~14.0.udeb ./pcmcia-storage-modules-3.16.0-30-generic-di_3.16.0-30.40~14.0.1_amd64.udeb
sudo mv ./serial-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd6.udeb ./serial-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./speakup-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd.udeb ./speakup-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./squashfs-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_am.udeb ./squashfs-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./storage-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04..udeb ./storage-core-modules-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb

# in /l/linux-signed-lts-utopic
cd $USB_MNT"/pool/main/l/linux-signed-lts-utopic"
sudo mv ./kernel-signed-image-3.16.0-30-generic-di_3.16.0-30.40~14.04.1.udeb ./kernel-signed-image-3.16.0-30-generic-di_3.16.0-30.40~14.04.1_amd64.udeb
sudo mv ./linux-signed-image-3.16.0-30-generic_3.16.0-30.40~14.04.1_amd.deb ./linux-signed-image-3.16.0-30-generic_3.16.0-30.40~14.04.1_amd64.deb

cd /vagrant

# unmount iso
sudo umount $ISO_MNT

# create the apps and images dir
sudo mkdir /vagrant/usb/goddard/apps && mkdir /vagrant/usb/goddard/images 

# function to create app tgz's
create_goddard_tgz () {

  if [ $# -eq 0 ]; then

    echo "No arguments supplied"
    exit 1

  fi

  if [ -z "$1" ]; then

    echo "Parameter #1 is zero length"
    exit 1

  else

    REPO_NAME=$1

  fi

  if [ -z "$2" ]; then

    echo "Parameter #2 is zero length"
    exit 1

  else

    TGZ_NAME=$2

  fi

  if [ ! -d ~/$REPO_NAME ]; then

    cd ~ && git clone https://github.com/praekelt/$REPO_NAME.git
    touch ~/$REPO_NAME/.git/hooks/post-merge && \
    chmod +x ~/$REPO_NAME/.git/hooks/post-merge && \
    echo "GIT_WORK_TREE=~/$TGZ_NAME git checkout -f" > ~/$REPO_NAME/.git/hooks/post-merge
    
    if [ ! -d ~/$TGZ_NAME ]; then
    
      mkdir ~/$TGZ_NAME
    
    fi
    
    cd ~/$REPO_NAME && GIT_WORK_TREE=~/$TGZ_NAME git checkout -f
  
  else
  
    cd ~/$REPO_NAME && git pull
  
  fi
  
  cd ~/$TGZ_NAME && npm install --production && cd ~
  sudo tar -czf ./$TGZ_NAME.tgz ./$TGZ_NAME

  return 0

}

# create node agent
create_goddard_tgz goddard-node-agent agent
sudo cp ~/agent.tgz /vagrant/usb/goddard/.

# create captive portal
create_goddard_tgz goddard-captive-portal captiveportal
sudo cp ~/captiveportal.tgz /vagrant/usb/goddard/apps/.

# create mama app
create_goddard_tgz mama-roots mama
sudo cp ~/mama.tgz /vagrant/usb/goddard/apps/.

# create wikipedia for schools app
if [ -d /vagrant/wikipedia-for-schools ]; then
  
  if [ ! -f /tmp/goddard.fifo ] ; then
    
    mkfifo /tmp/goddard.fifo
  
  fi
  
  sudo rm /vagrant/usb/goddard/apps/wikipedia*
  cd /vagrant
  sudo split -b 3G /tmp/goddard.fifo /vagrant/usb/goddard/apps/wikipedia-for-schools.tgz- | \
  sudo tar -czvf /tmp/goddard.fifo ./wikipedia-for-schools

fi

# copy files
echo "Copying Files. This takes a really long time. Don't be impatient. Don't stop it."
sudo cp -R /vagrant/usb/* $USB_MNT/.

echo "Copy goddard dist and pool"
sudo cp -R /vagrant/reprepro/dists/* $USB_MNT/dists/.
sudo cp -R /vagrant/reprepro/pool/main/* $USB_MNT/pool/main/.

# unmount usb
cd /vagrant
sudo umount $USB_MNT

echo "Done ...\r\n"
echo "---------------------------------------"
echo "| You may remove the disk and install |"
echo "---------------------------------------"

exit 0