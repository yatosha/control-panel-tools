#!/bin/bash

# Get the port number from user input
read -p "Enter port number to open: " PORT

# Check if CSF is installed, if not install it
if [ ! -d "/etc/csf" ]; then
    cd /usr/src
    rm -fv csf.tgz
    wget https://download.configserver.com/csf.tgz
    tar -xzf csf.tgz
    cd csf
    sh install.sh
fi

# Add the port to the CSF config if it does not exist
if grep -q "TCP_OUT =.*$PORT" /etc/csf/csf.conf; then
  echo "Port $PORT already exists in TCP_OUT line."
else
  sed -i "s/\(TCP_OUT = \)\(.*\)\$/\1\"\2,$PORT\"/" /etc/csf/csf.conf
  echo "Added port $PORT to TCP_OUT line."
fi

# Open the port in CSF
csf -a $PORT

# Optionally disable CSF testing
read -p "Disable CSF testing? (y/n): " DISABLE_TESTING
if [ "$DISABLE_TESTING" == "y" ]; then
    sed -i 's/TESTING = "1"/TESTING = "0"/' /etc/csf/csf.conf
    echo "CSF testing disabled."
fi

# Set RESTRICT_SYSLOG to 3
sed -i 's/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "3"/' /etc/csf/csf.conf

# Change SSH port to the new port number
/bin/sed -i "s/#Port 22/Port $PORT/g" /etc/ssh/sshd_config
/bin/sed -i "s/Port 22/Port $PORT/g" /etc/ssh/sshd_config

# Restart the SSH service
systemctl restart sshd

echo "Port $PORT opened and SSH port updated to $PORT."
