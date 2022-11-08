#!/bin/bash
clear

MAC_ADDR=$(ip addr show enp0s3 | grep "ether" | cut -c 19-32)
LVM=$(cat /etc/fstab | grep -q /dev/mapper/)
USING_LVM="yes"

if $LVM
then
	USING_LVM="yes"
fi


echo -e " #Architecture: $(uname -a)\n\r" \
		"#CPU physical: (Needs to be done)\n" \
		"#vCPU: $(nproc)\n" \
		"#Using lvm: $USING_LVM"
		"#Connections: $(who | wc -l)\n" \
		"#User log: $(users | wc -l)\n" \
		"#Network: $(hostname -I) ($MAC_ADDR)\n" \
