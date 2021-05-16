#!/bin/bash
# Created by Isuru Tharanga
# Version 3.0 - Mar 15, 2017

Black='\033[0;30m'
DarkGray='\033[1;30m'
Red='\033[0;31m'
LightRed='\033[1;31m'
Green='\033[0;32m'
LightGreen='\033[1;32m'
Orange='\033[0;33m'
Yellow='\033[1;33m'
Blue='\033[0;34m'
LightBlue='\033[1;34m'
Purple='\033[0;35m'
LightPurple='\033[1;35m'
Cyan='\033[0;36m'
LightCyan='\033[1;36m'
LightGray='\033[0;37m'
White='\033[1;37m'
NoColor='\033[0m'



status=$(sudo systemctl status bacula-fd | grep "Active:" | cut -d' ' -f5)


if [ "$status" = "failed" ]; then
echo -e "${LightBlue}----------------------------${NoColor}"
echo -e "${LightBlue}|Starting ${LightPurple}bacula-fd ${LightBlue}Service|${NoColor}"
echo -e "${LightBlue}----------------------------${NoColor}"
sudo systemctl restart bacula-fd
echo ""
fi

echo -e "${LightBlue}--------------------------${NoColor}"
echo -e "${LightBlue}|${LightPurple}bacula-fd ${LightBlue}Service Status|${NoColor}"
echo -e "${LightBlue}--------------------------"
cstatus=$(sudo systemctl status bacula-fd | grep "Active:" | cut -d' ' -f4,5)
echo -e ${LightGreen}$cstatus${NoColor}
echo ""



echo -e "${LightBlue}------------------${NoColor}"
echo -e "${LightBlue}|Select an ${Yellow}Option${LightBlue}|${NoColor}"
echo -e "${LightBlue}------------------${NoColor}"
PS3="Option: "

select opt in full incremental restore quit

do
case $opt in
full)
echo ""
echo -e "${LightBlue}----------------------${NoColor}"
echo -e "${LightBlue}|Starting ${LightGreen}Full ${LightBlue}Backup|${NoColor}"
echo -e "${LightBlue}----------------------${NoColor}"
bconsole <<END_OF_DATA
@output /tmp/garbage.log
messages
quit
END_OF_DATA

bconsole <<END_OF_DATA
@output /tmp/fullbackup.log
run job=isuru_full yes
wait
messages
quit
END_OF_DATA
echo ""

echo ""
echo -e "${LightBlue}----------------------${NoColor}"
echo -e "${LightBlue}|Bacula Backup ${LightGreen}Status${LightBlue}|${NoColor}"
echo -e "${LightBlue}----------------------${NoColor}"
cat /tmp/fullbackup.log
echo ""

bconsole <<END_OF_DATA
@output /tmp/recent.log
status client=isuru-fd
quit
END_OF_DATA

sed '/Terminated Jobs:/,/quit/!d' /tmp/recent.log | sed '1d;$d' >> /tmp/status.log

echo ""
echo -e "${LightBlue}-----------------------${NoColor}"
echo -e "${LightBlue}|${LightCyan}Recent ${LightBlue}Backup/Restore|${NoColor}"
echo -e "${LightBlue}-----------------------${NoColor}"
cat /tmp/status.log
echo ""

rm -rf /tmp/garbage.log
rm -rf /tmp/fullbackup.log
rm -rf /tmp/recent.log
rm -rf /tmp/status.log
break
;;

incremental)
echo ""
echo -e "${LightBlue}-----------------------------${NoColor}"
echo -e "${LightBlue}|Starting ${LightCyan}Incremental ${LightBlue}Backup|${NoColor}"
echo -e "${LightBlue}-----------------------------${NoColor}"
bconsole <<END_OF_DATA
@output /tmp/garbage.log
messages
quit
END_OF_DATA

bconsole <<END_OF_DATA
@output /tmp/incrementalbackup.log
run job=isuru_incremental yes
wait
messages
quit
END_OF_DATA
echo ""

echo ""
echo -e "${LightBlue}----------------------${NoColor}"
echo -e "${LightBlue}|Bacula Backup ${LightGreen}Status${LightBlue}|${NoColor}"
echo -e "${LightBlue}----------------------${NoColor}"
cat /tmp/incrementalbackup.log
echo ""

bconsole <<END_OF_DATA
@output /tmp/recent.log
status client=isuru-fd
quit
END_OF_DATA

sed '/Terminated Jobs:/,/quit/!d' /tmp/recent.log | sed '1d;$d' >> /tmp/status.log

echo ""
echo -e "${LightBlue}-----------------------${NoColor}"
echo -e "${LightBlue}|${LightCyan}Recent ${LightBlue}Backup/Restore|${NoColor}"
echo -e "${LightBlue}-----------------------${NoColor}"
cat /tmp/status.log
echo ""

rm -rf /tmp/garbage.log
rm -rf /tmp/incrementalbackup.log
rm -rf /tmp/recent.log
rm -rf /tmp/status.log
break
;;

restore)
echo ""
echo -e "${LightBlue}----------------------${NoColor}"
echo -e "${LightBlue}|Starting ${LightGreen}Full Restore ${LightBlue}|${NoColor}"
echo -e "${LightBlue}----------------------${NoColor}"
bconsole <<END_OF_DATA
@output /tmp/garbage.log
messages
quit
END_OF_DATA

bconsole <<END_OF_DATA
@output /tmp/restore.log
restore client=isuru-fd select current all done yes
1
wait
messages
quit
END_OF_DATA
echo ""

echo ""
echo -e "${LightBlue}----------------------${NoColor}"
echo -e "${LightBlue}|Bacula Backup ${LightGreen}Status${LightBlue}|${NoColor}"
echo -e "${LightBlue}----------------------${NoColor}"
cat /tmp/restore.log
echo ""

bconsole <<END_OF_DATA
@output /tmp/recent.log
status client=isuru-fd
quit
END_OF_DATA

sed '/Terminated Jobs:/,/quit/!d' /tmp/recent.log | sed '1d;$d' >> /tmp/status.log

echo -e "${LightBlue}-----------------------${NoColor}"
echo -e "${LightBlue}|${LightCyan}Recent ${LightBlue}Backup/Restore|${NoColor}"
echo -e "${LightBlue}-----------------------${NoColor}"
cat /tmp/status.log
echo ""

rm -rf /tmp/garbage.log
rm -rf /tmp/restore.log
rm -rf /tmp/recent.log
rm -rf /tmp/status.log
break
;;

quit)
break
;;

*)
echo ""
echo -e "${LightRed}Invalid input! ${LightGreen}Please Enter a valid input ${LightCyan}[ex: 1/2/3/4]${NoColor}"
esac
done
