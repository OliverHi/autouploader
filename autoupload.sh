#! /bin/bash

# requirements: inotify-tools, rclone (and setup)

# configuration
DOCUMENT_PATH="/mnt/extssd/scans/"
REMOTE_NAME="nextcloud:"

# -------------- program, don't change ---------------
inotifywait -m $DOCUMENT_PATH -e create -e moved_to |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action'"
        # retry is used as the upload might take some time after the initial creation of the file. Remove if not needed
        rclone --config /opt/autouploader/rclone.conf --retries-sleep 1s --retries 10 move ${dir}/${file} ${REMOTE_NAME}
        echo "Moved file '$file' to remote '$REMOTE_NAME'"
    done