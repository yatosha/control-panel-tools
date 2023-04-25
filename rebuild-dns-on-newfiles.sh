#!/bin/bash

# Monitor the /var/named directory for changes
inotifywait -m /var/named -e modify |
    while read path action file; do
        # Execute the rebuilddnsconfig script when a file is modified
        /scripts/rebuilddnsconfig
    done
