# Control Panel Tools
# cPanel and Directadmin

This repository contains a shell script that deletes DNS zone files for inactive domains in the /var/named/ directory on a cPanel server, and rebuilds the DNS configuration file based on the remaining DNS zones. The script uses the cPanel API to determine the list of active domains, and then deletes any DNS zone files for domains that are not active. The script can be run without downloading it by using the following command:

# Delete Inactive named .db files from cPanel

```
bash <(curl -s https://raw.githubusercontent.com/yatosha/cpanel-tools/main/delete_inactive_dns_zones_cpanel.sh)
````

Please note that as with any script that modifies system files, you should test this script on a non-production environment before running it on a live server. Additionally, make sure that all remaining DNS zones are working correctly after running the script and rebuilding the DNS configuration file.

# Easy CSF - Directadmin + cPanel
<ul>
  <li>This script simple reinstalls CSF</li>
<li>Open's SSH port in TCP_IN and TCP_OUT</li>
<li>Changes the port for SSH</li>
</ul>

Enough talk, here is the script
```
bash <(curl -s https://raw.githubusercontent.com/yatosha/control-panel-tools/main/easy-csf.sh)
````

# Rebuild named .db 
This script simply checks for changes in /var/named/ any change and it runs rebuild. Works on cPanel DNS Only
```
bash <(curl -s https://raw.githubusercontent.com/yatosha/control-panel-tools/main/rebuild-dns-on-newfiles.sh)
````

# Todo
Control Panel Detect for named files Delete
Rebuild script, make it work after reboots.
