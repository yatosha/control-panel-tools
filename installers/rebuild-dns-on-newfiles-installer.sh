#!/bin/bash

# Define variables
SCRIPT_DIR="/home/yatosha-dns-scripts"
SCRIPT_NAME="rebuild-dns-on-newfiles.sh"
CRON_FILE="/etc/cron.d/rebuild-dns-config"
RUN_DIR="/var/run"

# Remove the directory if it exists
if [[ -d "$SCRIPT_DIR" ]]; then
    rm -rf "$SCRIPT_DIR"
    rm -f /etc/cron.d/rebuild-dns-config
fi
echo "Old version removed Ok"

# Create the script directory if it doesn't exist
if [[ ! -d "$SCRIPT_DIR" ]]; then
    mkdir -p "$SCRIPT_DIR"
fi


# Download the script from GitHub
curl -sSL -o "$SCRIPT_DIR/$SCRIPT_NAME" "https://raw.githubusercontent.com/yatosha/control-panel-tools/main/$SCRIPT_NAME"
chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"

# Create the run directory if it doesn't exist
if [[ ! -d "$RUN_DIR" ]]; then
    mkdir -p "$RUN_DIR"
fi

# Create the cron file
echo "*/5 * * * * root $SCRIPT_DIR/$SCRIPT_NAME" > "$CRON_FILE"

# Set the correct permissions on the files and directories
chmod 644 "$CRON_FILE"
chown root:root "$CRON_FILE"
chown -R root:root "$SCRIPT_DIR"
chown -R root:root "$RUN_DIR"

echo "Script Installed Ok"