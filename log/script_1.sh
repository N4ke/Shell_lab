#!/bin/bash

# Launch example: ./script_1.sh /home/user/log N X
LOG_DIR=$1
THRESH_PERCENT=$2 # N
OLD_FILES=$3 # X
BACKUP_DIR="./backup"

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

get_folder_usage() {
    df $LOG_DIR --output=pcent | tail -n 1 | tr -dc '0-9'
}

USAGE=$(get_folder_usage)

if [ "$((USAGE))" -gt "$THRESH_PERCENT" ]; then
    echo "ARCHIVATION..."

    FILES=$(find "$LOG_DIR" -type f ! -name "*.sh"  -printf "%T@ %p\n" |
	sort -n | head -n "$OLD_FILES" | cut -d' ' -f2-)

    if [ -n "$FILES" ]; then
        ARCHIVE_NAME="$BACKUP_DIR/backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

	tar -czf "$ARCHIVE_NAME" $FILES
	echo "COMPLETE!"
    else
	echo "There are no old files"
    fi
else
    echo "Directory usage is $USAGE%. No archivation required..."
fi
