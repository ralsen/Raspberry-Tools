#!/bin/bash
# Script fuer inkrementelles Backup mit 30 taegigem Vollbackup

# #################################################################
#
# this script does a incremental back
#
# this variables maybe changed:
# BACKUPDIR = destination of the backups
# SOURCE = source of the backup that´s be done during execution
#
# at first a new directory with current date and time is generated
# then the whole last backup (with all files) will be linked 
# into the new one. After that the changed files will be copied
# with rsync into the new backup.
# A log-file will be generated and copied into the root of the
# new backup directory
# at last the new backup will be write protected
#
# #################################################################

PROC_NAME="rsynch V2.0" 

### Einstellungen ##
BACKUPDIR="/mnt/backup"           ## Pfad zum Backupverzeichnis
SOURCE="/home/pi/samba"                 ## Verzeichnis(se) welche(s) gesichert werden soll(en)
DATUM="$(date +%Y-%m-%d)"          ## Datumsformat einstellen
ZEIT="$(date +%H-%M-%S)"              ## Zeitformat einstellen >>Edit bei NTFS und Verwendung auch unter Windows : durch . ersetzen
#TIMESTAMP=${DATUM}"_"${ZEIT}          ## Zeitstempel
NEWBACKUPDIR=${BACKUPDIR}/$(date +%Y-%m-%d)_$(date +%H-%M-%S)
echo $NEWBACKUPDIR

PROC_LOG="${SOURCE}/rsync.log" 
#$(date +%Y-%m-%d)_$(date +%H-%M-%S)="${TIMESTAMP} [INFO   ] - " 

echo "----------------------">>$PROC_LOG
echo -n $(date +%Y-%m-%d)_$(date +%H-%M-%S) >>$PROC_LOG
echo " [INFO   ] - ${PROC_NAME} started">>$PROC_LOG
 
if [ ! -d "${BACKUPDIR}" ]; then
echo Hallo Chef,
echo backup could not be created. Directory ${BACKUPDIR} not found.
echo Mit freundlichem Gruss Backupscript
echo EOM
exit 1
fi

# das verlinken kann nur passieren wenn es wenigstens ein Backup gibt
# z.B. prüfen mit ls /mnt/hdd/backup|wc -l. Wenn 0 dann gibt es kein Backup
OLDBACKUPDIR=${BACKUPDIR}/"$(ls ${BACKUPDIR}|sort|tail -n1)"

echo  last backup: ${OLDBACKUPDIR}

echo "new  backup: "${NEWBACKUPDIR}

mkdir -p ${NEWBACKUPDIR}


if [ $? -ne 0 ]; then

echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) [ERROR  ] - new backup "'${NEWBACKUPDIR}'" could not be created.>>$PROC_LOG
# protect the backup again
sudo chmod 0755 ${BACKUPDIR}
exit 1
else

echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - link ""'${OLDBACKUPDIR}'" to "'${NEWBACKUPDIR}'". >>$PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - link ""'${OLDBACKUPDIR}'" to "'${NEWBACKUPDIR}'".
sudo cp -alv ${OLDBACKUPDIR}/* ${NEWBACKUPDIR}|tee -a $PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - done.">>$PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - done".

echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - sync ""'${OLDBACKUPDIR}'" to "'${NEWBACKUPDIR}'". >>$PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - sync ""'${OLDBACKUPDIR}'" to "'${NEWBACKUPDIR}'".
sudo rsync -av ${SOURCE}/* ${NEWBACKUPDIR} --exclude 'var' --progress|tee -a $PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - done.">>$PROC_LOG
echo $(date +%Y-%m-%d)_$(date +%H-%M-%S) "[INFO   ] - done."
fi 

DATUM="$(date +%Y-%m-%d)"          ## Datumsformat einstellen
ZEIT="$(date +%H-%M-%S)"              ## Zeitformat einstellen >>Edit bei NTFS und Verwendung auch unter Windows : durch . ersetzen
TIMESTAMPEND=${DATUM}"_"${ZEIT}          ## Zeitstempel
# NEWBACKUPDIR=${BACKUPDIR}/${TIMESTAMP}

echo -n $(date +%Y-%m-%d)_$(date +%H-%M-%S) >>$PROC_LOG
echo  " [INFO   ] - ${PROC_NAME} stopped">>$PROC_LOG

echo -n $(date +%Y-%m-%d)_$(date +%H-%M-%S) 
echo "${PROC_NAME} stopped"

# protect the backup again
sudo mv ${SOURCE}/rsync.log ${NEWBACKUPDIR}/rsync.log
echo protecting the backup
sudo chmod -R 0555 ${NEWBACKUPDIR}
echo all done
