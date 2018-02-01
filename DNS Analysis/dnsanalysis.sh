#!/bin/bash
# Adam Hancock
echo "Enter your email address:"
read email
###
 
rm -f output.csv
echo "Domain, IP, MX IP, Nameservers" >> output.csv
while read d; do
        p=`echo $d | sed -e 's/www.//g'`
website=`dig @8.8.8.8 +short $p | head -n1`
mx=`dig @8.8.8.8 +short mx $p | cut -d " " -f 2 | head -n1`
nameservers=`dig ns $p +short`
nameserver1=`echo $nameservers | head -n1`
mx1=`dig +short $p mx | sort -n | awk '{print $2; exit}' | dig +short -f - | head -n1`
echo "$p, $website, $mx1, $nameserver1" >> output.csv
done <domains.txt
echo "CSV attached" | mutt -s "domain check results" $email -a output.csv