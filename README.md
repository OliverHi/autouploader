# autouploader
Automatically upload new files in a local folder to (your) cloud

## What does this script do?
I wrote this script with one usecase in mind: I have a scanner in my network that scans to a shared Samba folder on my Raspberry Pi [smart home server](https://github.com/OliverHi/smarthomeserver). I was looking for a solution to upload from this server to my remote Nextcloud instance to share the scanned documents with all my devices. There is no auto-syncing command line client for Nextcloud so I built my own solution here.

This script monitors a local folder and moves all new files in this folder to a remote (cloud) location, in my case Nextcloud, while deleting the document locally. You are not limited to Nextcloud though, the script supports everything that [rclone supports](https://rclone.org/docs/).

## Installation
First you need to install the needed dependencies rclone and inotify. On a Raspbbery Pi running Raspbian this works with APT
```
sudo apt install rclone inotify-tools git
```

Next you need to set up a rclone config containing the data needed to reach your remote cloud. You can use `rclone config` and follow the wizard. This will create a config file in `~/.config/rclone/rclone.conf` that should look something like this:

```
[nextcloud]
type = webdav
url = https://example.com/nextcloud/remote.php/dav/files/user/Path/To/Remote/Folder
vendor = nextcloud
user = user
pass = some_random_encrypted_password
```

Now we can actually download this script and install it as a service.
```
# clone this repository locally
sudo git clone https://github.com/OliverHi/autouploader.git /opt/autouploader

# copy your rclone config
sudo cp ~/.config/rclone/rclone.conf /opt/autouploader/rclone.conf

# then install this script as a background service
sudo ln -s /opt/autouploader/autouploader.service /etc/systemd/system/autouploader.service
sudo systemctl daemon-reload
```

Now before you actually start the script open the autoupload.sh file and update the configuration at the start of the file to your liking. Then we can finally start the script by running these commands.
```
# start the script at system startup during boot
sudo systemctl enable autouploader.service

# start the script running
sudo systemctl start autouploader.service

# check and make sure the startup worked
sudo systemctl status autouploader.service

# also check
tail -f /var/log/scan-uploader.log
```

If everything is running fine you can now put files in the watched folder and they should automatically be moved to your Nextcloud instance.

## Updating
Updating this script can be easily done via git.

```
cd /opt/autouploader

# stop the service
sudo systemctl stop autouploader.service

# get the latest version
sudo git pull

# reload the systemd configuration (in case it changed)
sudo systemctl daemon-reload

# restart the service with your new version
sudo systemctl start autouploader.service

# check the status of the program
```