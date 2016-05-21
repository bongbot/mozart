if [ "$1" == "start" ]; then
 echo "starting rails"
 nohup rails s --binding=0.0.0.0 &
elif [ "$1" == "stop" ]; then
 echo "stopping rails"
 kill $(ps aux | awk '/rails/{print $2}')
fi
