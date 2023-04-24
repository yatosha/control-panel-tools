#!/bin/bash

# Script to delete DNS zone files for inactive domains in DirectAdmin
# and rebuild the DNS configuration file

# Get the list of active domains from DirectAdmin
ACTIVE_DOMAINS=$(cd /usr/local/directadmin/data/users; for user in *; do
  grep -r "domain=" /usr/local/directadmin/data/users/$user/domains/*.conf | awk -F= '{print $2}'
done | sort | uniq)

# Loop through the DNS zone files in /var/named and delete any that are not
# in the list of active domains
for file in /var/named/*.db; do
  DOMAIN=$(basename "$file" .db)
  if [[ ! " ${ACTIVE_DOMAINS[@]} " =~ " ${DOMAIN} " ]]; then
    rm "$file"
    echo "Deleted DNS zone file for inactive domain: $DOMAIN"
  fi
done

# Rebuild the DNS configuration file
/usr/local/directadmin/scripts/dns.sh
