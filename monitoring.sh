#!/bin/bash
# Monitoring script for Born2BeRoot, Works on standard debian (No packages were installed during this process)

# Network
MAC_ADDR=$(ip addr show enp0s3 | grep "ether" | cut -c 16-32)

# Cpu
CPU_PERC=$(top -b -n1 | grep "^%Cpu" | cut -c 10- | awk '{ printf("%.1f", $1 + $3) }')
VCPU_TOTAL=$(cat /proc/cpuinfo | grep "^physical id" | uniq | wc -l)

# Disk
DISK_USED=$(df 	-Bm | awk '{ j += $3 } END { print j }')
DISK_TOTAL=$(lsblk  | grep "^sda" | cut -c 32- | awk '{ print $3 }') #More accurate.
DISK_PERC=$(df 	-Bm | awk '{ k += $3 } {m += $4 } END { printf("%d", k/m*100)}')
USING_LVM="no"

if $(cat /etc/fstab | grep -q /dev/mapper/);
then
	USING_LVM="yes"
fi

# Memory
MEM_TOTAL=$(free -m | grep "^Mem" | awk '{print $2}')
MEM_USED=$(free -m  | grep "^Mem" | awk '{print $3}')
MEM_PERC=$(free -m  | grep "^Mem" | awk '{printf("%.2f", ($3 / $2) * 100)}')

wall "	#Architecture: $(uname -a)
			#CPU physical: $(nproc --all)
			#vCPU: $VCPU_TOTAL
			#Memory Usage: $MEM_USED/${MEM_TOTAL}MB (${MEM_PERC}%)
			#Disk Usage: $DISK_USED/${DISK_TOTAL} (${DISK_PERC}%)
			#CPU load: $CPU_PERC%
			#Last boot: $(who -b | cut -c 25-)
			#LVM use: $USING_LVM
			#Connections TCP : $(who | wc -l) ESTABLISHED
			#User log: $(users | wc -w)
			#Network: IP $(hostname -I) ($MAC_ADDR)
			#Sudo : $(cat /var/log/auth.log | grep "COMMAND" | wc -l) cmd" #Should work... crontab runs as sudo