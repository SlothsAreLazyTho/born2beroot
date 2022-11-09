#!/bin/bash
MAC_ADDR=$(ip addr show enp0s3 | grep "ether" | cut -c 19-32)
CPU_PERC=$(top -b -n1 | grep "%Cpu" | cut -c 10- | awk '{ printf("%.1f", $1 + $3) }')

DISK_TOTAL=$(df -Bg | awk '{ i += $4 } END { printf("%dG", i) }')
DISK_USED=$(df  -Bm | awk '{ j += $3 } END { print j }')
DISK_PERC=$(df  -Bm | grep "^/dev/mapper" | awk '{ k += $5 } END { printf("%d%%", k) }')

USING_LVM="no"

if $(cat /etc/fstab | grep -q /dev/mapper/);
then
	USING_LVM="yes"
fi


echo -e " #Architecture: $(uname -a)\n\r" \
		"#CPU physical: (Needs to be done)\n" \
		"#vCPU: $(nproc)\n" \
		"#Disk Usage: $DISK_USED/$DISK_TOTAL ($DISK_PERC)\n" \
		"#CPU Load: $CPU_PERC%\n" \
		"#Last boot: $(who -b | cut -c 25-40)\n" \
		"#Using lvm: $USING_LVM\n" \
		"#Connections: $(who | wc -l)\n" \
		"#User log: $(users | wc -l)\n" \
		"#Network: $(hostname -I) ($MAC_ADDR)\n" \
		"#Sudo: $(cat /var/log/auth.log | grep --text "COMMAND" | wc -l)\n"