#! /bin/bash

# requirements: inotify-tools, rclone (and setup)

# configuration
DOCUMENT_PATH="/mnt/extssd/scans/"
REMOTE_NAME="nextcloud:"
LOGFILE="/var/log/scan-uploader.log"

# -------------- program, don't change ---------------
inotifywait -m $DOCUMENT_PATH -e create -e moved_to |
    while read dir action file; do
        echo "$(date) - The file '$file' appeared in directory '$dir' via '$action'"
        rclone --config /opt/autouploader/rclone.conf move ${dir}/${file} ${REMOTE_NAME}
        echo "$(date) - Moved file '$file' to remote"
    done