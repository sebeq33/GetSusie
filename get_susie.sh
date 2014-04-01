#!/bin/sh
## get_susie.sh for get_susie in /home/monner_r/script/getsusie
## 
## Made by raphael monnerat
## Login   <monner_r@epitech.net>
## 
## Started on  Thu Nov 29 18:25:49 2012 raphael monnerat
## Last update Wed Mar 27 11:08:38 2013 sebastien bequignon
##


## move on get_susies directory to access get_susie's file
cd ~/scripts/get_susie/

if [ "$1" == '-kill' ]; then
    kill `ps x | grep -E ' sh.*get_susie.sh' | sed "s/^ *//" | grep -Ev ' grep*' | cut -d' ' -f1 | head -n 1`
    echo 'getsusie killed'
    exit 0
fi

if [ "$1" == '-list' ] || [ "$1" == "-display" ] || [ "$1" == "-show" ]
then
    cat *.info
    exit 0
fi

if [ "$1" == '-sleep' ]; then
    sleep $2
fi

if [ `sh check_instance.sh` $? -eq 1 ]; then
    exit 1;
fi

## save cookies session
if [ ! -f access.conf ]; then
    echo "access.conf not found, check directory" > 2
    exit 1
fi
wget -q --save-cookies cookies.txt `cat access.conf`

## rm entries from already passed day (today too) -------------------------------------------

sh rm_old_susie.sh

## display the next susie already took ------------------------------------------------------

if [ `sh get_next_susie.sh` $? -eq 1 ]; then
    exit 1
fi

## let's check susies in an infinite loop --------------------------------------------------

## start var
temp="/tmp/today_susie.info"

while [ 1 ]
do
    year=`printf %04d \`date +%Y\``
    month=`printf %02d \`date +%m\``
    day=`date +%d`
    ## we start at tomorrow
    day=`printf %02d \`expr $day + 1\``

    echo "start searching susie at $day/$month/$year"

    ## check susie for next 20 days
    daytoend=20
    while [ $daytoend -gt 0 ]
    do
	date=$day$month$year
	page="https://www.epitech.eu/intra/index.php?section=susie&date=$date"
	## get susie page for $date
	if [ `sh try_get_pages.sh $page` $? -eq 1 ]; then
	    exit 1
	fi
	#empty tmp file
	> $temp

        ## get number of susies new and already known
	nbsusie=`cat index* | grep "main_page" -c`
	nbline=`cat info/$date.info 2>/dev/null | wc -l`
	echo "$day/$month/$year => $nbsusie susie(s)"
	i=1
	## check all susies retrieved
	while [ $i -le $nbsusie ]
	do
	    susiename=`cat index* | grep -A1 -E 'width=\"100\">[^<]*' | cut -d'>' -f2 | sed "s/--//" | grep -E "[a-Z]" | sed "s/^ *//" | head -n $i | tail -n 1`
	    hour=`cat index* | grep -A1 -E 'width=\"70\">[^<]*' | cut -d'>' -f2 | sed "s/--//" | sed "s/^ *//" | grep -E "[0-9]" | head -n $i | tail -n 1`
	    subject=`cat index* | grep -Eo "[0-9]&date=[0-9]{8}\">[^<]*" | cut -d'>' -f2 | head -n $i | tail -n 1`
	    nbplace=`grep -Eo "([0-9]{1,2}/[0-9]{2})&" index* | sed 's/&//' | sed -n ${i}p`
	    ## search if this susie need to be display 
	    if [ -f "info/$date.info" ]; then
	    	display=0
	    	j=1
	    	while [ $j -lt $nbline ]
	    	do
	    	    if [ "$susiename" == "`cat info/$date.info | head -n $j | tail -n 1 | cut -d':' -f3`" ];then
	    		echo
                        ## search if it's not full anymore or place was added
	    		if [ `cat info/$date.info | head -n $j | tail -n 1 | cut -d':' -f4 | cut -d'/' -f2` != `echo $nbplace | cut -d'/' -f2` ];then
	    		    display=1
	    		fi
	    		if [ `cat info/$date.info | head -n $j | tail -n 1 | cut -d':' -f4 | cut -d'/' -f1` -gt `echo $nbplace | cut -d'/' -f1` ];then
	    		    display=1
	    		fi
	    	    fi
	    	    j=`expr $j + 1`
	    	done
	    else
	    	## display only if still disponible
	    	if [ `echo $nbplace | cut -d '/' -f1` -lt `echo $nbplace | cut -d '/' -f2` ]; then
	    	    display=1
	    	else
	    	    display=0
	    	fi
	    fi
	    if [ $display -eq 1 ]; then
		## notify new susie and open the web page to take it if user agreed
		ANSWER=$(xmessage -timeout 10 "SUSIE ($susiename) $day/$month/$year $hour $subject ($nbplace)" -buttons Accept,Decline -print)
		if [ "$ANSWER" == 'Accept' ]; then
		    google-chrome "https://www.epitech.eu/intra/index.php?section=susie&date=$date" &
		else
		    if [ "$ANSWER" != "Decline" ]; then
			## if window is closed it mean STOP DISTURB ME
			sleep 750
		    fi
		fi
	    fi
	    ## add info in the tmp file
	    echo "$day/$month/$year:$susiename:$subject:$nbplace" >> $temp
	    i=`expr $i + 1`
	done
	if [ `cat $temp | wc -l` -gt 0 ]; then
	    ## replace previous susies by new ones
	    cat $temp > info/$date.info
	fi

	## next day
	day=`printf %02d \`expr $day + 1\``
	if [ $day -ge 32 ]; then
	    if [ $month -ge 13 ]; then
		year=`printf %04d \`expr $year + 1\``
		month=1
	    else
		month=`printf %02d \`expr $month + 1\``
	    fi
	    day="01"
	fi

	daytoend=`expr $daytoend - 1`
    done
    ##wait 15 min (750 sec) before next check
    echo "sleep 750 =D"
    sleep 750
    echo "Let's roll again =D, CHEEEEEECK SUSIIIIIE"
done
