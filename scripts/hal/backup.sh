# Back up HAL's files to remote backup server, defined by `$BACKUP_USER@$BACKUP_HOST`.
#
# Any deleted files are deleted from $TARGET_DIR, but also archived under $ARCHIVE_DIR.
#
# Archives older than $ARCHIVE_TTL_DAYS days are also deleted
#
# Any local files listed in $EXCLUSIONS are excluded from sync. However, they also prevent
# remote files and directories from being deleted if they happen to be on the remote
# server. This may result in the following rsync error:
#
#   cannot delete non-empty directory: foo/bar
#
# There are ways around this (see: https://superuser.com/q/543419) but easiest solution is
# to manually delete the offending files from the remote servers.
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

# Trailing slash on the SOURCE_DIR is important. It means to sync the
# _contents_ of a dir, not the dir itself.
# See: http://qdosmsq.dunbar-it.co.uk/blog/2013/02/rsync-to-slash-or-not-to-slash/
SOURCE_DIR="/var/data/$(whoami)/"
TARGET_DIR="/var/data/$(hostname)/$(whoami)"

EXCLUSIONS="$(dirname "$0")/backup_exclusions.txt"

ARCHIVE_DIR="/var/data-archive/$(hostname)/$(whoami)/$NOW"
ARCHIVE_TTL_DAYS=100

echo "Logging to $LOGFILE"

# Execute the backup with `rsync`
#
# Reference: definition of `rsync` flags
#
#   --delete        delete extraneous files from dest dirs
#   --backup        make backups (see --suffix & --backup-dir)
#   --backup-dir    make backups into hierarchy based in DIR
#   --exlucde-from  read exclude patterns from FILE
#   -e              custom command for execution
#   a               "archive mode", equivalent to `-rlptgoD`
#     r                 recurse into directories
#     l                 copy symlinks as symlinks
#     p                 preserve permissions
#     t                 preserve modification times
#     g                 preserve group
#     o                 preserve owner (super-user only)
#     D                 same as --devices --specials
#       --devices           preserve device files (super-user only)
#       --specials          preserve special files
#   t               preserve modification times
#   v               verbose
#   z               compress file data during the transfer
#   h               output numbers in a human-readable format
#   P               same as --partial --progress
#
# The above options effectively try to preserve all information about 
# the file (owner, permissions, etc...).
#
# `rsync` will also try to match up and preseve the "owner" and "group", 
# even if they have different UID / GID on the source and target system.
#
# See: https://serverfault.com/a/964240/219765
echo "" >> $LOGFILE
echo "=== Backing up $SOURCE_DIR -> $BACKUP_USER@$BACKUP_HOST:$TARGET_DIR" >> $LOGFILE
time rsync --delete --backup --backup-dir=$ARCHIVE_DIR --exclude-from $EXCLUSIONS -atvzhP -e "ssh -p $SSH_PORT" $SOURCE_DIR $BACKUP_USER@$BACKUP_HOST:$TARGET_DIR >> $LOGFILE 2>&1

# Delete older archive directories
# The find, print, delete command was a pain to write. Most combinations of 
# `find... -exec {} \;` or `find .. | xargs` involved multiple layers of 
# bash escape characters that didn't correctly print the file before deleting.
#
# To test this you can easily create folders with a certain modified timestamp
# (e.g. 99 days old and 101 days old) on the remote server. Those modified
# less than $ARCHIVE_TTL_DAYS days ago should be preserved
#
#   mkdir 101_days_ago
#   touch -d "101 days ago" 101_days_ago
#
#   mkdir 99_days_ago
#   touch -d "99 days ago" 99_days_ago

echo "" >> $LOGFILE
echo "=== Removing the following archives older than $ARCHIVE_TTL_DAYS days" >> $LOGFILE
ssh $BACKUP_USER@$BACKUP_HOST -p $SSH_PORT "find $(dirname $ARCHIVE_DIR)/* -maxdepth 0 -type d -mtime +$ARCHIVE_TTL_DAYS -print0 | xargs -0 -I % echo \"echo %; rm -rf %\" | sh" >> $LOGFILE 2>&1

