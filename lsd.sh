echo
echo "-----  diese Platten gibt es  -----"
sudo fdisk -l|grep "Disk /dev/s"
echo
echo "----- hier sind sie gemountet -----"
lsblk
echo
echo "-----   hier die blkid Info   -----"
sudo blkid
echo
echo "-----   hier die /etc/fstab   -----"
cat /etc/fstab

 
