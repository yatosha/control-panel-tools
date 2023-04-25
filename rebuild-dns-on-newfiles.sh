#!/bin/bash

# Monitor the /var/named directory for changes to .db files
inotifywait -m /var/named -e modify --format '%f' --exclude '!*.db' |
    while read file; do
        # Execute the rebuilddnsconfig script when a .db file is modified
        /scripts/rebuilddnsconfig
    done
