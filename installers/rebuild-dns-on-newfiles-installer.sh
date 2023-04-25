#!/bin/bash

# Install dependencies
yum -y install inotify-tools

# Create the directory for the scripts if it doesn't exist
mkdir -p /home/yatosha-dns-scripts

# Download the rebuild-dns-on-newfiles.sh script
curl -o /home/yatosha-dns-scripts/rebuild-dns-on-newfiles.sh https://raw.githubusercontent.com/yatosha/control-panel-tools/main/rebuild-dns-on-newfiles.sh

# Make the script executable
chmod +x /home/yatosha-dns-scripts/rebuild-dns-on-newfiles.sh

# Add a crontab entry to run the script on reboot
(crontab -l 2>/dev/null; echo "@reboot /home/yatosha-dns-scripts/rebuild-dns-on-newfiles.sh >/dev/null 2>&1") | crontab -

# Start the script as a background process
nohup /home/yatosha-dns-scripts/rebuild-dns-on-newfiles.sh >/dev/null 2>&1 &

echo "The rebuild-dns-on-newfiles.sh script has been installed and started as a background process."
