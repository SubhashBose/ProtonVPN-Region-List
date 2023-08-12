rm -f region_list.txt
for file in ProtonVPN_server_configs/*.udp.ovpn
do
	ip=`grep 'remote ' $file | head -1 | awk '{print $2}'`
	domain=`echo $file | sed 's/.udp.ovpn//g'`
	ipinfo=`curl -s https://ipinfo.bose.dev/$ip`
	region=`echo "$ipinfo" |grep -E 'city|region' | sed -r 's/.*: "(.*)",/\1/g' | awk 1 ORS=', ' | rev| cut -c3- |rev`
	
	echo "$domain $ip    $region" |tee -a region_list.txt
done
