## if -gt 2 ?!?
## yeah it's magic. with backquote wc -l return 1 more than expected, and only with backquote !!!

# result=`ps x | grep -E ' sh.*get_susie.sh' | grep -Ev '*grep*'`
# echo $result
# echo -------------------------
if [ `ps x | grep -E ' sh.*get_susie.sh' | grep -Ev '*grep*' | wc -l` -gt 1 ]; then 
    ## ask if the program should be run
    ANSWER=$(xmessage "Etes vous sur de vouloir lancer get_susies ? celui ci est deja lance !" -buttons Accept,Decline -print)
    if [ "$ANSWER" == 'Decline' ]; then
	exit 1
    else
	kill `ps x | grep -E ' sh.*get_susie.sh' | sed "s/^ *//" | grep -Ev ' grep*' | cut -d' ' -f1 | head -n 1`
    fi
fi
