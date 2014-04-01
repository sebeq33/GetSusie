if [ `ls -1 | grep -E "^index*" | wc -l` -gt 0 ]; then
    rm index*
fi

get=0
path=$1

while [ $get -eq 0 ]
do
    wget -q --load-cookies cookies.txt $path
    if [ `ls -1 | grep -E "^index*" | wc -l` -gt 0 ]; then
	get=1
    else
	ANSWER=$(xmessage "Fail wget susie, on continue a chercher ?" -buttons Accept,Decline -print)
	if [ "$ANSWER" == 'Decline' ]; then
	    exit 1
	fi
    fi
    sleep 1
done
