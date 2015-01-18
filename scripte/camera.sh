#!/bin/bash

# Times
date=`date --rfc-2822`
date_format_with_seconds=`date -d "$date" +%Y%m%d%H%M%S`
date_format_hour=`date -d "$date" +%l`
date_format_minute=`date -d "$date" +%`
date_format_day=`date -d "$date" +%d`
date_format_month=`date -d "$date" +%m`
date_format_year=`date -d "$date" +%Y`
date_format_name_month=`date -d "$date" +%b`
date_format_name_=`date -d "$date" +%e`
date_format_unixtime=`date -d "$date" +%s`
#echo $date_format_with_seconds

# Constants
pi=$(echo "scale=10; 4*a(1)" | bc -l)

# Capture-Names
capture_last='cur_capture.jpg'
capture_30m='30m_capture.jpg'
capture_60m='60m_capture.jpg'
capture_timelapse=$date_format_with_seconds.jpg
capture_twitpic=$date_format_with_seconds-twitpic.jpg
capture_temp='/root/capture/temp.jpg'

# Paths
path_capture_timelapse=/root/capture/fullsize/
path_capture_twitpic=/root/capture/twitpic/
path_capture_processed=/root/capture/processed/

# Overlay
font='/root/fonts/Sansation_Regular.ttf'
coresec=`wget -q -O - https://hamburg.freifunk.net/nodes_ffhh/nodes.json | python -c 'import sys, json; data = json.load(sys.stdin);coresec = [item for item in data["nodes"] if item["name"] == "CoreSEC-HH1"];print json.dumps(coresec[0])'`
uptime=$(echo $coresec | python -c 'import sys, json; print json.load(sys.stdin)["uptime"];')
uptime_s=$(echo "scale=2;$uptime/60/60" | bc)
clientcount=$(echo $coresec | python -c 'import sys, json; print json.load(sys.stdin)["clientcount"];')
model=$(echo $coresec | python -c 'import sys, json; print json.load(sys.stdin)["model"];')
firmware=$(echo $coresec | python -c 'import sys, json; print json.load(sys.stdin)["firmware"];')

# Do it!

# Create folders
mkdir -p /root/capture/fullsize/$date_format_year$date_format_month$date_format_day
mkdir -p /root/capture/twitpic/$date_format_year$date_format_month$date_format_day

# Create Snapshots
/usr/bin/raspistill -o $capture_temp -n -q 100 -x 'GPS.GPSLatitudeRef=N' -x 'GPS.GPSLongitudeRef=E' -x 'GPS.GPSLatitude=53/1,34/1,43908/1000' -x 'GPS.GPSLongitude=10/1,1/1,56217/1000' -x 'IFD0.Artist=Florian Strankowski' -x 'IFD0.ImageWidth=1920' -x 'IFD0.ImageLength=1440' -x 'IFD0.ImageDescription=Raspberry PI Camera at Adolph Schoenfelder Strasse 68, 22083 Hamburg, Germany' -x 'IFD0.Copyright=Copyright (c) 2014 Florian Strankowski'
gm convert -size 1920x1440 /root/capture/temp.jpg -resize 1920x1440 $path_capture_timelapse$date_format_year$date_format_month$date_format_day/$capture_timelapse
# Apply Overlay and write Text
gm convert -size 1024x768 /root/capture/temp.jpg -resize 1024x768 -pointsize 17 -font $font -fill white -draw 'text 850,652 "@PiHamPi"' -draw 'text 75,652 "CoreSEC-HH1"' /root/capture/temp1.jpg
# Overlay depends on # of WLAN-Clients
if [ $clientcount -eq 0 ]
then gm composite -gravity center /root/fonts/bg_0_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 1 ]
then gm composite -gravity center /root/fonts/bg_1_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 2 ]
then gm composite -gravity center /root/fonts/bg_2_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 3 ]
then gm composite -gravity center /root/fonts/bg_3_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 4 ]
then gm composite -gravity center /root/fonts/bg_4_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 5 ]
then gm composite -gravity center /root/fonts/bg_5_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 6 ]
then gm composite -gravity center /root/fonts/bg_6_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -eq 7 ]
then gm composite -gravity center /root/fonts/bg_7_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
elif [ $clientcount -gt 7 ]
then gm composite -gravity center /root/fonts/bg_7_client.png /root/capture/temp1.jpg /root/capture/temp2.jpg
fi
gm convert /root/capture/test3.jpg -pointsize 10 -font $font -fill white -draw "text 30,680 'UPTIME (HOURS)'" -draw "text 173,680 '$uptime_s'" -draw "text 30,695 'CLIENTS (#)'" -draw "text 173,695 '$clientcount'" -draw "text 30,720 '$model'" -draw "text 30,735 'FIRMWARE (VERSION)'" -draw "text 173,735 '$firmware'" $path_capture_twitpic$date_format_year$date_format_month$date_format_day/$capture_twitpic

cp $path_capture_twitpic$date_format_year$date_format_month$date_format_day/$capture_twitpic $path_capture_twitpic/last.jpg
rm -f /root/capture/temp.jpg /root/capture/temp1.jpg /root/capture/temp2.jpg
