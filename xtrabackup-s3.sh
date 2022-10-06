#!/bin/bash

while getopts p:b: flag
do
    case "${flag}" in
        p) PROJECT=${OPTARG};;
        b) BACKET_PATH=${OPTARG};;
        *) echo "Usage: $0 -p -b" >&2
           exit 1 ;;
    esac
done

test -z "$PROJECT" || test -z "$BACKET_PATH" && printf "Project Name or Backet Path is undefined\nUsage: %s [-n] [-p]\n" "$0"; exit

BACKUP_NAME=$PROJECT-$(date +%F_%H-%M-%S).xbstream
BACKUP_NAME_LAST=$PROJECT-last.xbstream
BACKET_PATH_FULL=$PROJECT:$BACKET_PATH/$PROJECT
WORK_DIR=/tmp/xtrabackup_tmp

# Checking rclone & xtrabackup are exists
test ! -x "$(which "rclone")" && echo "Rclone not found"; exit
test ! -x "$(which "xtrabackup")" && echo "Rclone not found"; exit
test ! -f ~/.config/rclone/rclone.conf && echo "Rclone configuration not found."; exit

# Preparing work dir
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || (echo "$WORK_DIR not found" && exit)

# Making backup
xtrabackup --backup \
--stream=xbstream \
--extra-lsndir=/tmp \
--target-dir=/tmp \
--compress >"$BACKUP_NAME" 2>>/var/log/xtrabackup.log

# Copying to S3 and removing work dir
rclone move "$BACKUP_NAME" "$BACKET_PATH_FULL/"
rclone copyto "$BACKET_PATH_FULL/$BACKUP_NAME" "$BACKET_PATH_FULL/$BACKUP_NAME_LAST"