#!/bin/sh
rm -rf /home/$(whoami)/.ytcache
/bin/clear
re=1
#redo
while [  $re != q  ]
do


echo -e "\e[1;34m*********************************\e[0m"
echo -e  "\e[1;34m*********youtube script **********\e[0m"
echo -e "\e[1;34m*********************************\e[0m"

echo -e "\e[1;31m Enter what you want to search:\e[0m"
read x ;
clear
#echo $x

#echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=50)"  | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-playlist vve-check clearfix"' > /home/jerome/.ytcache
#grep without any playlist
#echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=50)"  | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-playlist vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="yt-lockup-playlist-item-length">' > /home/jerome/.ytcache
echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreeload=10)"      | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-play    list vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="    yt-lockup-playlist-item-length">' > /home/jerome/.ytcache


#re view search result
re2=1
while [ $re2 -eq 1 ]
do
y=1

z=$(cat /home/$(whoami)/.ytcache | cut -c282-400 | sed 's/" aria.*//g; s/^/ 1. /g'  | wc -l)

#echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=10)"  | grep '<a href="/watch?v=' 


while [ $y  -le $z ]
do

printf " $y. "
#cat /home/$(whoami)/.ytcache |  sed   's/.*"  title="//g; s/" aria.*//g'  | head -$y | tail -1
#cat /home/$(whoami)/.ytcache | cut -c282-400 | sed 's/.*title="//g; s/" aria.*//g' | head -$y | tail -1
#echo -e  "\e[1;33m$(cat /home/$(whoami)/.ytcache  | sed 's/.*"  title="//g; s/" aria.*//g; s/rel="spf-prefetch//g'| head -$y | tail -1)\e[0m"
#echo -e "\e[1;31m$(cat /home/$(whoami)/.ytcache | sed 's/.*"  title="//g; s/" aria.*//g; s/" rel="spf-prefetch//g' |head -$y | tail -1)\e[0m"
echo -e "\e[1;31m$(cat /home/$(whoami)/.ytcache | sed 's/.*"  title="//g; s/" aria.*//g; s/" rel="spf-prefetch//g; s/&amp;/\&/g' |head -$y | tail -1)\e[0m"


#channel
#cat .ytcache  | grep /channel/  | sed 's/.*><a href="//g; s/" class="yt-uix-sessionlink.*//g' | head -$y | tail -1
#cat .ytcache  | grep /channel/  | sed 's/.*><a href="//g; s/.*" >//g; s/<\/a><\/div>.*//g' 

#cat /home/$(whoami)/.ytcache | cut -c282-400  | sed 's/" aria.*//g' | head -$y | tail -1
cat /home/$(whoami)/.ytcache | cut -c85-95| head -$y | tail -1

echo " " 

y=$( expr $y + 1 )

done
echo -e "\e[1;36mEnter the number you want to watch or enter q to exit \e[0m"
#echo " enter d to show only discription"
echo  " Enter n to go to other pages"
read p ;


if [ "$p" != q ] && [ "$p" != n ] && [[ "$p" =~ ^[0-9]+$ ]]
then
q=$(cat /home/$(whoami)/.ytcache | cut -c85-95 | head -$p | tail -1 )
clear

echo -e "\e[0;37m Now Playing: \e[0m"
echo " "
echo -e "\e[1;31m$(cat /home/$(whoami)/.ytcache  | sed 's/.*"  title="//g; s/" aria.*//g; s/rel="spf-prefetch//g; s/&amp;/\&/g'| head -$p | tail -1)\e[0m"
echo -e "\e[1;31m$(echo "Link: https://www.youtube.com/watch?v=$q")\e[0m"

echo " "
echo -e "\e[0;37m Description: \e[0m"
#if [ $p -eq d ]
#then
#echo : enter the number you want to see"
#read q
echo -e  "\e[1;34m$(firejail wget -qO-  "https://www.youtube.com/watch?v=$q" | grep "watch-description-extras"  | sed 's/<br[^>]*>/\n/g; s/<[^>]*>//g')\e[0m"
#fi
echo "" 

firejail --quiet   mpv --ytdl-format=best --quiet "https://www.youtube.com/watch?v=$q"

mpv=1 # for conflict


fi


if [ "$p" = q ]
then
clear
re2=0
#re=q   # complete exit var
rm -rf /home/$(whoami)/.ytcache
fi
#echo "see the search result again? press 1"
#read re2;
#re2=p


#next page
if [ "$p" = n ]
then
echo -e "\e[1;37mEnter the page number\e[0m"
read xx

if [ "$xx" -eq 1 ] && [[ "$xx" =~ ^[0-9]+$ ]]
then
echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreeload=10)"      | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-play    list vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="    yt-lockup-playlist-item-length">' > /home/jerome/.ytcache
fi

if [ "$xx" != 1 ] && [[ "$xx" =~ ^[0-9]+$ ]]
then
xx=$(expr $xx - 1) 
clear
page=$(echo "="$( (wget -qO- https://www.youtube.com/results?search_query=linux&spfreload=10) | grep '="Go to page' | sed 's/.*results?search_query=//g' |sed 's/.*;sp=//g' | sed 's/" class="yt-uix-button.*//g' | sed '1d' | head -$xx | tail -1 )"&spfreeload=10")
rage="$x&sp$page"
#echo $rage
echo -e "\e[1;37mpage no $(expr $xx + 1)\e[0m"
echo "URL: https://www.youtube.com/results?search_query="$rage" "
echo ""
echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$rage")" | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-playlist vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="yt-lockup-playlist-item-length">' > /home/jerome/.ytcache
fi
fi # end of $p = n


if  [ "$p" != n ] && [ "$p" != q  ] && [[ "$mpv" != 1 ]]
then
 
echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$p"&spfreeload=10)"      | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-play    list vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="    yt-lockup-playlist-item-length">' > /home/jerome/.ytcache
x="$p"
fi


mpv=0 # reset conflict var



done
clear
#echo "search again? if yes press 1"
#read  re;
clear
done
rm -rf /home/$(whoami)/.ytcache
