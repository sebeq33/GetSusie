
year=`printf %04d \`date +%Y\``
month=`printf %02d \`date +%m\``
day=`printf %02d \`date +%d\``

i=1
nbline=`ls -1 | grep -E "*.info" | wc -l`
while [ $i -lt $nbline ]
do
    yearfile=`ls -1 | grep -E "*.info" | head -n $i | tail -n 1 | cut -d'.' -f1 | cut -c 5-8`
    monthfile=`ls -1 | grep -E "*.info" | head -n $i | tail -n 1 | cut -d'.' -f1 | cut -c 3-4`
    dayfile=`ls -1 | grep -E "*.info" | head -n $i | tail -n 1 | cut -d'.' -f1 | cut -c 1-2`
    if [ $yearfile -le $year ] && [ $monthfile -le $month ] && [ $dayfile -le $day ] 
    then
	if [ -e "$dayfile$monthfile$yearfile.info" ] ; then
	    rm "$dayfile$monthfile$yearfile.info"
	fi
    fi
    i=`expr $i + 1`
done
