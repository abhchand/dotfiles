# Back up HAL's files to remote backup server, defined by `$BACKUP_USER@$BACKUP_HOST`.
#
# Any deleted files are deleted from $TARGET_DIR, but also archived under $ARCHIVE_DIR.
#
# Archives older than $ARCHIVE_TTL_DAYS days are also deleted
#
# Cron Entry:
#   > SHELL=/bin/bash
#   > BASH_ENV=/home/abhishek/.bashrc
#   >
#   > 0 * * * * BACKUP_USER=... BACKUP_HOST=... SSH_PORT=... sh /path/to/this/script.sh

if [ -z "$BACKUP_USER" ] || [ -z "$BACKUP_HOST" ] || [ -z "$SSH_PORT" ]; then
  echo "Please specify all the following: BACKUP_USER, BACKUP_HOST, SSH_PORT"
  exit
fi

NOW=`date "+%Y%m%d_%H%M%S"`
LOGFILE="/tmp/${NOW}_rysnc.log"
SOURCE_DIR="/home/abhishek/Documents/Documents/"
TARGET_DIR="/var/data/$HOSTNAME"
ARCHIVE_DIR="/var/data-archive/$HOSTNAME/$NOW"

ARCHIVE_TTL_DAYS=100

echo "" >> $LOGFILE
echo "=== Backing up $SOURCE_DIR" >> $LOGFILE
time rsync --delete --backup --backup-dir=$ARCHIVE_DIR -atvzhP -e "ssh -p $SSH_PORT" $SOURCE_DIR $BACKUP_USER@$BACKUP_HOST:$TARGET_DIR >> $LOGFILE 2>&1

# Delete older archive directories

TO_BE_DELETED=`ssh $BACKUP_USER@$BACKUP_HOST -p $SSH_PORT 'find "$(dirname $ARCHIVE_DIR)/*" -type d -mtime +$ARCHIVE_TTL_DAYS -maxdepth 1'`

echo "" >> $LOGFILE
echo "=== Removing archives: $TO_BE_DELETED" >> $LOGFILE
ssh $BACKUP_USER@$BACKUP_HOST -p $SSH_PORT 'echo $TO_BE_DELETED | xargs rm -rf'
