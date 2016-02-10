#!/bin/bash

source config.sh


if [ "$1" == "" ]; then
#	echo "usage $0 <xid>"
#	echo "xid may be optained by"
#	echo "xprop _NET_WM_PID | cut -d' ' -f3"
#	exit 1
	TITLE=$(xprop WM_NAME | cut -d '"' -f2)
	X_ID=$(xwininfo -tree -root -all | egrep "$TITLE" | sed -e 's/^ *//' | cut -d' ' -f1)
else
	X_ID=$1
fi


echo "Screencast"
echo "- Window xid $X_ID"
echo "- Framerate $X_FPS fps"

SUFFIX=$(date +"%Y%m%d%H%M%S")

# --- Camera source stuff -----------
# camera resolution
# choose something that it supports.
#CAM_H="720"
#CAM_W="1280"
#CAM_FPS="30/1"
#CAM_DEVICE="/dev/video0"
#CAM_FORMAT="YV12"
echo "Camera:"
echo "- Recording from $CAM_DEVICE"
echo "- Resolution ${CAM_W}x${CAM_H}"
echo "- Framerate  $CAM_FPS fps"

## - to give to move cursor
SLEEPTIME=3
echo "sleeping for $SLEEPTIME seconds"
echo "- move your mouse where you want to recording to show..."
for i in $(seq $SLEEPTIME); do
	sleep 1;
done

## debugging - choose one
## go here for details
# https://developer.ridgerun.com/wiki/index.php/How_to_generate_a_Gstreamer_pipeline_diagram_%28graph%29
#export GST_DEBUG_DUMP_DOT_DIR=.
unset GST_DEBUG_DUMP_DOT_DIR

OUTFILE="$SUFFIX-recvid.ogv"
echo "Recording"
echo "- outpufile $OUTFILE"

# record and store with compressing
gst-launch -v -e \
  alsasrc device-name=$ALSA_DEVICE  ! audioconvert ! queue ! vorbisenc ! queue ! oggrecvid. \
  ximagesrc use-damage=0 do-timestamp=true xid=$X_ID ! video/x-raw-rgb,framerate=\(fraction\)$X_FPS ! ffmpegcolorspace \
    ! tee name=vid \
      ! queue name=fileoutput ! theoraenc quality=48 ! oggmux name=oggrecvid ! filesink location=$OUTFILE \
      vid. ! queue name=windowoutput ! timeoverlay ! ffmpegcolorspace ! xvimagesink sync=false \

#  --gst-debug-level=3



echo File saved:
echo "  $OUTFILE"
echo
echo "To view:"
echo "  vlc $OUTFILE"
