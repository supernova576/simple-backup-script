#!/bin/bash

###################
### Global Vars ###
###################

PATH_TO_LOG="/path/to/log"
SOURCE_DIR="/path/to/source/dir"
DEST_DIR="/path/to/backup"
declare -a DEST_DIRS=("/path/to/backup1" "/path/to/backup2")

########################
### Helper Functions ###
########################

# $1 = message
error_exit()
{
    log_append "ERROR" $1
    exit 1
}

# $1 = log level
# $2 = message
log_append()
{
    time_stamp=$(date +"%d.%m.%Y %H:%M:%S")
    echo -e "$time_stamp\t$1\t$2" >> $PATH_TO_LOG
}

###################
### Main Script ###
###################

# create new tar
log_append "INFO" "Tryingk to create a new tar file at $SOURCE_DIR/backup.tar"
tar -cf $SOURCE_DIR/backup.tar -C $SOURCE_DIR $SOURCE_DIR/* ||  error_exit "Could not create tar file at $SOURCE_DIR/backup.tar"
log_append "INFO" "Successfully created a new tar file at $SOURCE_DIR/backup.tar"

# md5sum new tar
md5sum_local=$(md5sum $SOURCE_DIR/backup.tar | awk '{ print $1 }')
log_append "INFO" "MD5SUM of local tar is $md5sum_local"

#check if destination file is present
for DEST_DIR in "${DEST_DIRS[@]}"; do
    log_append "INFO" "Processing destination directory: $DEST_DIR"

    if [ -e $DEST_DIR/backup.tar ]; then
        md5sum_remote=$(md5sum $DEST_DIR/backup.tar | awk '{ print $1 }')
        log_append "INFO" "MD5SUM of remote tar ($DEST_DIR) is $md5sum_remote"

        if [ "$md5sum_local" != "$md5sum_remote" ]; then
            log_append "INFO" "MD5SUMs differ, copying new tar to $DEST_DIR"
            cp $SOURCE_DIR/backup.tar $DEST_DIR/backup.tar || error_exit "Could not copy new tar to $DEST_DIR"
            log_append "INFO" "Successfully copied new tar to $DEST_DIR"
        else
            log_append "INFO" "MD5SUMs are the same, no need to copy new tar to $DEST_DIR"
        fi
    else
        log_append "INFO" "Remote tar does not exist... copying new tar to $DEST_DIR"
        cp $SOURCE_DIR/backup.tar $DEST_DIR/backup.tar || error_exit "Could not copy new tar to $DEST_DIR"
        log_append "INFO" "Successfully copied new tar to $DEST_DIR"
    fi
done

# remove local tar
log_append "INFO" "Removing local tar at $SOURCE_DIR/backup.tar"
rm $SOURCE_DIR/backup.tar || error_exit "Could not remove local tar at $SOURCE_DIR/backup.tar"
log_append "INFO" "Successfully removed local tar at $SOURCE_DIR/backup.tar"

log_append "SUCCESS" "Backup script completed successfully"

exit 0