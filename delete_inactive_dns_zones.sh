#!/bin/bash

# Script description: This script deletes DNS zone files for inactive domains in the /var/named/ directory,
# and rebuilds the DNS configuration file based on the remaining DNS zones.

# Get the list of active domains
active_domains=$(/usr/local/cpanel/bin/whmapi1 listaccts | grep "domain:" | awk '{print $2}')

# Loop through the .db files in /var/named/
for file in /var/named/*.db; do
  # Extract the domain name from the file path
  domain=$(basename $file .db)
  
  # Check if the domain is active
  if [[ "${active_domains[@]}" =~ "${domain}" ]]; then
    echo "Skipping $domain"
  else
    echo "Deleting $domain"
    rm -f $file
  fi
done

# Rebuild the DNS configuration file
/scripts/rebuilddnsconfig
