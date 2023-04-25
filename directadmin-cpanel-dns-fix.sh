#!/bin/bash
# bash <( curl -s 'https://raw.githubusercontent.com/yatosha/directadmin_dns/master/yatosha-dns-fix.sh' )

echo "*************************************"
echo "Reading all named files to named.conf"
echo "*************************************"
read -p "Do you want to read domains to named.conf? (y/n) " confirm
if [[ $confirm == [yY] ]]; then
  bash <( curl -s 'https://raw.githubusercontent.com/yatosha/directadmin_dns/master/fix.sh' )
else
  echo ""
  echo "Skipped"
fi

echo ""
echo "Done"
echo ""
echo ""
echo "Fixing named .db files permission"
chown named:named /var/named/*.db
echo ""
echo "Done"
echo ""
echo ""
echo "Starting Domain sync"
# Get the server's IP address
ipaddr=$(hostname -I | awk '{print $1}')

# Get the domain list from the output of the command
domains=$(cat /etc/virtual/domainowners | cut -d ":" -f 1)

# Loop through the domain list and run the command for each domain
for domain in $domains
do
  /opt/yatosha-dns/yatosha-dns.sh sync "$domain" --ipaddr $ipaddr
done
echo "Fixing Completed"
