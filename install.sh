#!/bin/bash

cp -r bin /opt/vyatta/
cp -r sbin /opt/vyatta/

cp -r vyatta-op /opt/vyatta/share/
cp -r vyatta-cfg /opt/vyatta/share/

cp netdev/veth /opt/vyatta/etc/netdevice.d/

if [ -z "`grep games /etc/default/vyatta`" ]; then
	echo "" >> /etc/default/vyatta
	echo "# added by vrf-vyatta" >> /etc/default/vyatta
	echo "declare -x PATH=/usr/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games" >> /etc/default/vyatta
fi
