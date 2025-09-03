#!/bin/bash

get_system_info() {
    ARCH=$(uname -a)
    PHYSICAL_CPU=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
    VIRTUAL_CPU=$(grep -c "^processor" /proc/cpuinfo)
    MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
    MEM_PERC=$(free | awk '/Mem:/ {printf("%.2f"), $3/$2*100}')
    DISK_TOTAL=$(df -h --total | grep "total" | awk '{print $2}')
    DISK_USED=$(df -h --total | grep "total" | awk '{print $3}')
    DISK_PERC=$(df --total | grep "total" | awk '{print $5}')
    CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    LAST_BOOT=$(who -b | awk '{print $3 " " $4}')
    LVM_USE=$(lsblk | grep "lvm" &> /dev/null && echo "yes" || echo "no")
    TCP_CONN=$(ss -t state established | grep -c ESTAB)
    USER_LOG=$(who | wc -l)
    IP=$(hostname -I | awk '{print $1}')
    MAC=$(ip link show | awk '/ether/ {print $2; exit}')
    SUDO_CMDS=$(journalctl _COMM=sudo | grep -c COMMAND)

echo "Architecture: $ARCH
CPU physical : $PHYSICAL_CPU
vCPU : $VIRTUAL_CPU
Memory Usage: $MEM_USED/${MEM_TOTAL}MB (${MEM_PERC}%)
Disk Usage: $DISK_USED/$DISK_TOTAL ($DISK_PERC)
CPU load: ${CPU_LOAD}%
Last boot: $LAST_BOOT
LVM use: $LVM_USE
Connections TCP : $TCP_CONN ESTABLISHED
User log: $USER_LOG
Network: IP $IP ($MAC)
Sudo : $SUDO_CMDS cmd"
}

echo "$(get_system_info)"
