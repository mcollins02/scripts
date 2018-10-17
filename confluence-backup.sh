#!/bin/bash -x
#
DATE=$(date +"%m-%d-%Y")
STIME=$(date +"%T")
LLOG=/mnt/backup/logs/confluence-backup-$DATE.log
BACKUP_DIR="/mnt/backup/confluence"

#################################################
##   Script to backup confluence
#################################################

echo "##########################################" > $LLOG
echo "##   Starting backup confluence script    " >>$LLOG
echo "##   on $DATE at $STIME                   " >>$LLOG
echo "##########################################" >>$LLOG

## confluence
CONFL_APP_DIR="/opt/atlassian/confluence"
CONFL_DB="confluence"
CONFL_USER=""
CONFL_PASS=""

echo "##########################################" >>$LLOG
echo "##   Starting Backup Postgres DB          " >>$LLOG
echo "##########################################" >>$LLOG

DB_BKP_FILE="${BACKUP_DIR}/${CONFL_DB}-${DATE}-dump.gz"
su - postgres -c "cd /tmp; /usr/bin/pg_dump confluence | gzip > "${DB_BKP_FILE}""

CURTIME1=$(date +"%T")
echo "##########################################" >>$LLOG
echo "##   Starting Backup files and data       " >>$LLOG
echo "##   at $CURTIME1                         " >>$LLOG
echo "##########################################" >>$LLOG

BKP_APP_DATA_FILE="${BACKUP_DIR}/Confl-APP-DATA-${DATE}.tar.gz"
BKP_APP_FILE="${BACKUP_DIR}/Confl-APP-${DATE}.tar.gz"
CONFL_DATA_DIR="/var/atlassian/application-data/confluence"
CONFL_APP_DIR="/opt/atlassian/confluence"
tar -h -czf ${BKP_APP_DATA_FILE} ${CONFL_DATA_DIR}
tar -h -czf ${BKP_APP_FILE} ${CONFL_APP_DIR}

CURTIME2=$(date +"%T")
echo "##########################################" >>$LLOG
echo "##   cleaning up backup directory...      " >>$LLOG
echo "##   at $CURTIME2                         " >>$LLOG
echo "##                                        " >>$LLOG
echo "##   List of files to be removed...       " >>$LLOG
echo "##########################################" >>$LLOG

FILECOUNT=`/bin/ls ${BACKUP_DIR}| /usr/bin/wc -l`
 if [ $FILECOUNT -gt 8 ]; then
     find ${BACKUP_DIR} -mtime +7 -exec ls -l {} \;  >>$LLOG
     find ${BACKUP_DIR} -mtime +7 -exec rm {} \;
 fi

FTIME=$(date +"%T")
echo "##########################################" >>$LLOG
echo "##   Confluence Backup script Finished... " >>$LLOG
echo "##   on $DATE at $FTIME                   " >>$LLOG
echo "##########################################" >>$LLOG
