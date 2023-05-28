#!/usr/bin/env -S bash

curl -s https://raw.githubusercontent.com/SubhashBose/ProtonVPN-Region-List/main/region_list.txt > pv.regions.tmp

#(echo "round-trip min/avg/max/stddev = 0/999999/0/0 ms"; ping -c 5 -t 2 8.8.8.8) | grep avg |tail -1

echo -n '' > pv.ping.tmp
awk '{print $2}' pv.regions.tmp |  while read ip
do
	sh -c "echo `(echo 'round-trip min/avg/max/stddev = 0/999999/0/0 ms'; ping -c 10 -t 2 $ip) | grep avg | tail -1 | cut -d '/' -f 5` $ip >> pv.ping.tmp" & 
done

while [ "`wc -l pv.regions.tmp | awk '{print $1}'`" -gt "`wc -l pv.ping.tmp | awk '{print $1}'`" ]; 
do
    sleep 1
done

topip=`sort -g pv.ping.tmp | head -1 | awk '{print $2}'`

echo `grep $topip pv.regions.tmp` `grep $topip pv.ping.tmp | awk '{print $1}'`ms

rm -f pv.*.tmp 2> /dev/null