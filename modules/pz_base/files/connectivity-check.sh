#!/bin/bash
#
# Monitor for connection loss and restart
#
#
#
#
TARGET_HOST='1.1.1.1'
count=$(ping -c 3 $TARGET_HOST | grep -E "icmp_seq=[0-9] ttl" | wc -l)
if [ $count -eq 0 ]; then
    echo "$(date)" "Target host" $TARGET_HOST "unreachable, Rebooting!" | logger
    /sbin/shutdown -r 0
else
    logger Connectivity check passed.
fi