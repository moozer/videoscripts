#!/bin/bash

source config.sh


if [ -z "$1" ]; then
#	echo "usage $0 <xid>"
#	echo "xid may be optained by"
#	echo "xprop _NET_WM_PID | cut -d' ' -f3"
#	exit 1
    echo "Plaese select windows to record from....."
	TITLE=$(xprop WM_NAME | cut -d '"' -f2)
	X_ID=$(xwininfo -tree -root -all | egrep "$TITLE" | sed -e 's/^ *//' | cut -d' ' -f1)
else
	X_ID=$1
fi

if [ -z "$2" ]; then
	DEBUGLVL=0
else
	DEBUGLVL=$2
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
gst-launch-1.0 \
  --gst-debug-level=$DEBUGLVL \
  ximagesrc use-damage=false do-timestamp=true xid=$X_ID \
    ! video/x-raw,framerate=\(fraction\)$X_FPS \
    ! progressreport \
    ! tee name=vid \
    vid. ! queue ! videoconvert ! videorate \
         ! video/x-raw,framerate=\(fraction\)$OUT_FPS \
         ! theoraenc ! outmux. \
    vid. ! queue ! timeoverlay ! ximagesink sync=false \
  pulsesrc do-timestamp=true \
    ! tee name=audio \
    audio. ! queue ! audioconvert ! vorbisenc ! outmux. \
    audio. ! wavescope style=0 ! videoconvert ! timeoverlay ! ximagesink sync=false \
  oggmux name=outmux ! filesink location=$OUTFILE \

#~ audio. ! wavescope style=0 ! videoconvert ! xvimagesink \


#~ gst-launch-1.0 \
  #~ --gst-debug-level=$DEBUGLVL \
  #~ ximagesrc use-damage=false do-timestamp=true xid=$X_ID  ! video/x-raw,framerate=\(fraction\)$X_FPS !  \
    #~ tee name=vid ! \
      #~ timeoverlay ! ximagesink sync=true \
      #~ vid. ! videoconvert ! x264enc bitrate=$BITRATE ! outmux. \
  #~ pulsesrc do-timestamp=true ! \
    #~ tee name=audio ! \
      #~ wavescope style=0 ! videoconvert ! xvimagesink \
      #~ audio. ! audioconvert ! voaacenc ! outmux. \
  #~ mp4mux name=outmux ! filesink location=$OUTFILE \


      #~ vid. ! videoconvert ! x264enc bitrate=$BITRATE ! outmux. \

  #~ pulsesrc do-timestamp=true ! audioconvert ! voaacenc ! outmux. \
  #~ mp4mux name=outmux ! filesink location=$OUTFILE \
      

      
#      vid. ! filesink location=$OUTFILE
      
      
#      videoconvert ! videorate ! x264enc ! outmux. \
#  mp4mux name=outmux ! queue ! filesink location=$OUTFILE \


      
      
  #~ pulsesrc do-timestamp=true ! audioconvert ! voaacenc ! outmux. \
  #~ 

  #\device-name=$ALSA_DEVICE   ! voaacenc
  #  queue name=windowoutput ! timeoverlay ! videoconvert ! xvimagesink sync=false \


#    ! tee name=vid \
#      vid. ! 
#     ! queue name=fileoutput ! x264enc bitrate=$BITRATE ! outmux. \
#   pulsesrc device-name=$ALSA_DEVICE  ! audioconvert ! voaacenc ! outmux. \
#  mp4mux name=outmux ! filesink location=$OUTFILE


#  --gst-debug-level=3

#~ gst-launch-1.0 filesrc location=$INNAME ! decodebin name=bin \
  #~ bin. ! progressreport \
  #~ ! videoscale ! x264enc bitrate=$BITRATE ! queue ! outmux. \
  #~ bin. ! audioconvert ! voaacenc ! outmux. \
  #~ mp4mux name=outmux ! filesink location=$OUTNAME \
  #~ --gst-debug-level=$DEBUGLVL

echo
echo "---------------"
echo "File saved:"
echo "  $OUTFILE"
echo "To view:"
echo "  vlc $OUTFILE"
echo "---------------"
echo
