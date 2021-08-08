#!/bin/bash

PROC_NAME="bksdx V1.0"

PROC_DIR="pi"
LOG_FILE="bksd.log"

PROC_PATH="/home/${PROC_DIR}"
LOG_PATH="/home/${PROC_DIR}/log"
PROC_LOG="${LOG_PATH}/${LOG_FILE}"

datum=$(date "+%Y-%m-%d %H:%M:%S:%3N")
datumInfo="${datum} [INFO   ] - "

echo "----------------------">>$PROC_LOG
echo -n $datumInfo >>$PROC_LOG
echo " ${PROC_NAME} started">>$PROC_LOG

echo "----------------------"
echo -n $datumInfo
echo " ${PROC_NAME} started"  


echo
echo ----- diese Platten gibt es -----
sudo fdisk -l|grep "Disk /dev/s"
echo
echo ----- hier sind sie gemountet -----
lsblk
li=`lsblk`

read -p "welche Disk soll kopiert werden?" disk
diskspace=$disk" "

echo
echo $disk
read -p "ist wirklich korrekt? Abbruch mit ctrl-C" inp
echo

if [[ $li == *$diskspace* ]]; then 
  echo jetzt gehts los
  sudo dd if=/dev/mmcblk0 of=/dev/${disk} bs=1MB status=progress
fi

datum=$(date "+%Y-%m-%d %H:%M:%S:%3N")
datumInfo="${datum} [INFO   ] - "

echo -n $datumInfo >>$PROC_LOG
echo " ${PROC_NAME} stopped">>$PROC_LOG

echo -n $datumInfo
echo " ${PROC_NAME} stopped"   
