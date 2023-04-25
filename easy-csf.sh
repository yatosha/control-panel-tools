#!/bin/bash

# Get port from user input
read -p "Enter port number to allow: " PORT

# Check if csf is installed
if [ -d "/etc/csf" ]; then
    echo "csf is already installed"
else
    cd /usr/src
    rm -fv csf.tgz
    wget https://download.configserver.com/csf.tgz
    tar -xzf csf.tgz
    cd csf
    sh install.sh
fi

# Enable port in csf
if [ "$1" == "--disable-test" ]; then
    sed -i "s/^TESTING = \"1\"/TESTING = \"0\"/" /etc/csf/csf.conf
fi
sed -i "s/^TCP_IN = \"/TCP_IN = \"$PORT,/" /etc/csf/csf.conf
if grep -q "^TCP_OUT = \".*7162\"" /etc/csf/csf.conf; then
    sed -i "s/^TCP_OUT = \".*7162\"/TCP_OUT = \"20,21,22,25,53,853,80,110,113,443,587,993,995,2222,$PORT\"/" /etc/csf/csf.conf
else
    sed -i "s/^TCP_OUT = \"/TCP_OUT = \"$PORT,/" /etc/csf/csf.conf
fi
csf -r

# Enable port for ssh
/bin/sed -i "s/#Port 22/Port $PORT/g" /etc/ssh/sshd_config
/bin/sed -i "s/Port 22/Port $PORT/g" /etc/ssh/sshd_config
service sshd restart

# Set RESTRICT_SYSLOG to 3
sed -i "s/^RESTRICT_SYSLOG = \".*\"/RESTRICT_SYSLOG = \"3\"/" /etc/csf/csf.conf

echo "Port $PORT has been opened and ssh port has been changed to $PORT"
