#!/bin/bash

# Times
date=`date --rfc-2822`
uhrzeit=`date -d "$date" +%H`:`date -d "$date" +%M`

# Paths
path_capture_twitpic_last=/root/capture/twitpic/last.jpg

/root/tweet.py $path_capture_twitpic_last "Die Adolph Schoenfelder Straße um $uhrzeit Uhr #hamburg #webcam #raspberrypi http://alsterlab.de"
