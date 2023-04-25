#!/bin/bash

# Prompt the user to enter a port number
read -p "Enter the port number to open: " PORT

# Check if CSF is installed by looking for the /etc/csf directory
if [ -d "/etc/csf" ]; then
  echo "CSF is already installed."
else
  echo "CSF is not installed. Installing..."
  cd /usr/src
  rm -fv csf.tgz
  wget https://download.configserver.com/csf.tgz
  tar -xzf csf.tgz
  cd csf
  sh install.sh
fi

# Add the port to the TCP_IN and SSH_IN configuration options in CSF
sed -i "s/TCP_IN = /TCP_IN = $PORT,/g" /etc/csf/csf.conf
sed -i "s/SSH_IN = /SSH_IN = $PORT,/g" /etc/csf/csf.conf

# Add the port to the TCP_OUT configuration option in CSF
sed -i "s/TCP_OUT = /TCP_OUT = $PORT,/g" /etc/csf/csf.conf

# Disable the CSF testing mode if it is enabled
if grep -q "^TESTING = \"1\"" /etc/csf/csf.conf; then
  sed -i "s/TESTING = \"1\"/TESTING = \"0\"/g" /etc/csf/csf.conf
fi

# Set the RESTRICT_SYSLOG configuration option to 3
sed -i "s/RESTRICT_SYSLOG = \"0\"/RESTRICT_SYSLOG = \"3\"/g" /etc/csf/csf.conf

# Restart CSF to apply the changes
csf -r

# Display a message indicating that the port has been opened and the syslog restriction has been set
echo "Port $PORT has been opened in CSF for both SSH and TCP inbound traffic, and TCP outbound traffic, and the syslog restriction has been set to 3."

# Change SSH port to the specified port and restart SSH service
/bin/sed -i "s/#Port 22/Port $PORT/g" /etc/ssh/sshd_config
/bin/sed -i "s/Port 22/Port $PORT/g" /etc/ssh/sshd_config
service sshd restart

# Display a message indicating that the SSH port has been changed and the SSH service has been restarted
echo "SSH port has been changed to $PORT and the SSH service has been restarted."
