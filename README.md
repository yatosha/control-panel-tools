# Control Panel Tools
# cPanel and Directadmin

This repository contains a shell script that deletes DNS zone files for inactive domains in the /var/named/ directory on a cPanel server, and rebuilds the DNS configuration file based on the remaining DNS zones. The script uses the cPanel API to determine the list of active domains, and then deletes any DNS zone files for domains that are not active. The script can be run without downloading it by using the following command:

# Delete Inactive named .db files from cPanel
bash <(curl -s https://raw.githubusercontent.com/yatosha/cpanel-tools/main/delete_inactive_dns_zones_cpanel.sh)

Please note that as with any script that modifies system files, you should test this script on a non-production environment before running it on a live server. Additionally, make sure that all remaining DNS zones are working correctly after running the script and rebuilding the DNS configuration file.

# Easy CSF - Directadmin + cPanel
'bash <(curl -s https://raw.githubusercontent.com/yatosha/control-panel-tools/main/easy-csf.sh)'
