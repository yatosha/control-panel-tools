#!/bin/bash

# Get the modification time of the newest .db file in the /var/named directory
newest_file=$(find /var/named -type f -name '*.db' -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}')
newest_time=$(stat -c %Y "$newest_file")

# Get the modification time of the last rebuild
last_time=$(cat /var/run/rebuild-dns-config.time 2>/dev/null)

# If the newest .db file has been modified since the last rebuild, rebuild the DNS configuration
if [[ $newest_time -gt $last_time ]]; then
    /scripts/rebuilddnsconfig
    echo $newest_time > /var/run/rebuild-dns-config.time
fi
