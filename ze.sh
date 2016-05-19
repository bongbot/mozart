if [ "$1" == "start" ]; then
 echo "starting zeus"
 nohup zeus start &
elif [ "$1" == "stop" ]; then
 echo "stopping zeus"
 kill $(ps aux | awk '/zeus/{print $2}')
fi
