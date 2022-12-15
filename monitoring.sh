#!/bin/bash
# Monitoring script for Born2BeRoot, Works on standard debian (No packages were installed during this process)

#Network (Unfortunately debian doesn't use lshw at default... )
ADAPTER="enp0s3"
MAC_ADDR=$(ip addr show $ADAPTER | grep "ether" | cut -c 16-32)

# Cpu
CPU_PERC=$(top -b -n1 | grep "%Cpu" | cut -c 10- | awk '{ printf("%.1f", $1 + $3) }')
VCPU_TOTAL=$(cat /proc/cpuinfo | grep "^physical id" | wc -l)

# Disk
DISK_TOTAL=$(df -Bg | awk '{ i += $4 } END { printf("%d", i) }')
DISK_USED=$(df -Bm | awk '{ j += $3 } END { print j }')
DISK_PERC=$(df -Bm | grep "^/dev/mapper" | awk '{ k += $2 } { m += $3 } END { printf("%d", m/k*100) }')
USING_LVM="no"

if $(cat /etc/fstab | grep -q /dev/mapper/);
then
		USING_LVM="yes"
fi

# Memory
MEM_TOTAL=$(free -m | grep "^Mem" | awk '{print $2}')
MEM_USED=$(free -m | grep "^Mem" | awk '{print $3}')
MEM_PERC=$(free -m | grep "^Mem" | awk '{ printf("%.2f", ($3 / $2) * 100) }')

wall "			#Architecture: $(uname -a)
				#CPU physical: $(nproc --all)
				#vCPU: $VCPU_TOTAL
				#Memory Usage: $MEM_USED/${MEM_TOTAL}MB (${MEM_PERC}%)
				#Disk Usage: $DISK_USED/${DISK_TOTAL}G (${DISK_PERC}%)
				#CPU load: $CPU_PERC%
				#Last boot: $(who -b | cut -c 25-40)
				#LVM use: $USING_LVM
				#Connections TCP : $(who | wc -l) ESTABLISHED
				#User log: $(users | wc -l)
				#Network: IP $(hostname -I) ($MAC_ADDR)
				#Sudo : $(cat /var/log/auth.log | grep --text "COMMAND" | wc -l) cmd" #Should work... crontab runs as sudo