#!/bin/bash
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/magic.sh --output /home/pabxserver/magic.sh --silent &
pid=$!
wait $pid
ls /root
sleep 1
chmod +x /home/pabxserver/magic.sh
ls
sleep 1
sed -i 's/\r$//' /home/pabxserver/magic.sh

curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/pabxserverhap22.sh --output /home/pabxserver/pabxserverhap22-2.sh --silent &
pid=$!
wait $pid
chmod +x /home/pabxserver/pabxserverhap22-2.sh
sleep 1
sed -i 's/\r$//' /home/pabxserver/pabxserverhap22-2.sh