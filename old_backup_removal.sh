#!/bin/bash

# this script will remove the files in a certain path
# based on some rules regarding access time of each file
#
# my use case is this:
# I have a script that does DB backup every half hour - paranoia, right? :)
#
# for the last 24 hours I need to be sure I have all the back-ups
#
# for the last 72 hours to 24 hours I need to keep some 
#     of the backups (accessed at hours 1,7,14,19)
#
# for the last 7 days to 72 hours I need to keep even less
#     of the backups (accessed at hours 7 and 14)
#
# for the last 30 days to 7 days I need to keep one file
#     per day (accessed at hour 7)
#
# for the last 90 days to 30 days I need to keep one file
#     per week (accessed monday hour 7)
#
# for the last 365 days to 90 days I need to keep one file
#     per month (accessed day 30 of the month, hour 7)
#
# I don't want to keep backup files older that 365 days


BACKUP_PATH=/var/backups/mysql
NOW=`date +%s | tr -d "\n"`

#timings
T1=$((24*3600))
T2=$((3*24*3600))
T3=$((7*24*3600))
T4=$((30*24*3600))
T5=$((90*24*3600))
T6=$((365*24*3600))

lt_t1(){
        #do nothing. bash script force us to have something defined inside a function. we can't have just {}
	DO=nothing
}
gt_t1_lt_t2(){
	HOURMINUTE_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%H%M | tr -d "\n"`
	if [[ $HOURMINUTE_OF_FILE != "0100" && $HOURMINUTE_OF_FILE != "0700" && $HOURMINUTE_OF_FILE != "1400" && $HOURMINUTE_OF_FILE != "1900" ]]
	then
		rm -rf $1
	fi
}
gt_t2_lt_t3(){
	HOURMINUTE_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%H%M | tr -d "\n"`
	if [[ $HOURMINUTE_OF_FILE != "0700" && $HOURMINUTE_OF_FILE != "1400" ]]
	then
		rm -rf $1
	fi
}
gt_t3_lt_t4(){
	HOURMINUTE_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%H%M | tr -d "\n"`
	if [[ $HOURMINUTE_OF_FILE != "0700" ]]
	then
		rm -rf $1
	fi
}
gt_t4_lt_t5(){
	WEEKDAY_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%u | tr -d "\n"`
	HOURMINUTE_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%H%M | tr -d "\n"`
	if [[ $HOURMINUTE_OF_FILE != "0700" && $WEEKDAY_OF_FILE != "1" ]]
	then
		rm -rf $1
	fi
}
gt_t5_lt_t6(){
	MONTHDAY_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%d | tr -d "\n"`
	HOURMINUTE_OF_FILE=`date --date="\`stat --printf=%x $1\`" +%H%M | tr -d "\n"`
	if [[ $HOURMINUTE_OF_FILE != "0700" && $MONTHDAY_OF_FILE != "01" ]]
	then
		rm -rf $1
	fi
}
gt_t6(){
	rm -rf $1
}


for f in $BACKUP_PATH/*.sql.gz
#for f in /var/backups/mysql/all-databases-2013-03-17-03-00.sql.gz
do
	FILE_TIME=`stat --printf=%Y $f`
	
	if [ $(($NOW-$FILE_TIME)) -lt $T1 ];
	then
		lt_t1 $f
		continue
	fi

	if [ $(($NOW-$FILE_TIME)) -gt $T1 -a $(($NOW-$FILE_TIME)) -lt $T2 ];
	then
		gt_t1_lt_t2 $f
		continue
	fi

	if [ $(($NOW-$FILE_TIME)) -gt $T2 -a $(($NOW-$FILE_TIME)) -lt $T3 ];
	then
		gt_t2_lt_t3 $f
		continue
	fi


	if [ $(($NOW-$FILE_TIME)) -gt $T3 -a $(($NOW-$FILE_TIME)) -lt $T4 ];
	then
		gt_t3_lt_t4 $f
		continue
	fi


	if [ $(($NOW-$FILE_TIME)) -gt $T4 -a $(($NOW-$FILE_TIME)) -lt $T5 ];
	then
		gt_t4_lt_t5 $f
		continue
	fi


	if [ $(($NOW-$FILE_TIME)) -gt $T5 -a $(($NOW-$FILE_TIME)) -lt $T6 ];
	then
		gt_t5_lt_t6 $f
		continue
	fi


	if [ $(($NOW-$FILE_TIME)) -gt $T6 ];
	then
		gt_t6 $f
		continue
	fi

done

exit 0
