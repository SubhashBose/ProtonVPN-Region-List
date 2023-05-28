#!/usr/bin/env -S bash

curl -s https://raw.githubusercontent.com/SubhashBose/ProtonVPN-Region-List/main/region_list.txt > pv.regions.tmp

echo -n '' > pv.ping.tmp
ptimeout='2'
if [[ $(uname -s) == Darwin* ]]; then
	ptimeout="${ptimeout}000"
fi

awk '{print $2}' pv.regions.tmp |  while read ip
do
	sh -c 'echo `(echo "/avg///999999//"; ping -c 5 -W '"$ptimeout $ip"') | grep avg | tail -1 | cut -d "/" -f 5`ms  `grep '"$ip"' pv.regions.tmp` >> pv.ping.tmp' & 
done

while [ "`wc -l pv.regions.tmp | awk '{print $1}'`" -gt "`wc -l pv.ping.tmp | awk '{print $1}'`" ]; 
do
    sleep 1
done

sort -g pv.ping.tmp | head -1

#topip=`sort -g pv.ping.tmp | head -1 | awk '{print $2}'`

#echo `grep $topip pv.regions.tmp` `grep $topip pv.ping.tmp | awk '{print $1}'`ms

rm -f pv.*.tmp 2> /dev/null
