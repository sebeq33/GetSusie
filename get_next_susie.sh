page="https://www.epitech.eu/intra/index.php?section=susie"
if [ `sh try_get_pages.sh $page` ]; then
    exit 1
fi

susiename=`cat index* | grep -A1 -E '<td class="default0">>*' | tail -n 1 | sed 's/^[ \t]*//'`
if [ "$susiename" != "" ]; then
    date=`cat index* | grep -A1 -E 'width=\"50\">[^<]*' | cut -d'>' -f2 | sed "s/--//" | sed "s/^ *//" | grep -E "[0-9]" | grep -E "/" | head -n 1`
    hour=`cat index* | grep -A1 -E 'width=\"70\">[^<]*' | cut -d'>' -f2 | sed "s/--//" | sed "s/^ *//" | grep -E "[0-9]" | head -n 1`
    subject=`cat index* | grep -Eo '[0-9]&date=\">[^<]*' | cut -d'>' -f2 | head -n 1`
    nbplace=`grep -Eo "([0-9]{1,2}/[0-9]{2})&" index* | cut -d':' -f2 | cut -d'&' -f1 | head -n 1`
    xmessage -timeout 60 "YOUR NEXT SUSIE IS : ($susiename) $date $hour $subject ($nbplace)"
fi
