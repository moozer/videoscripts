#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "usage"
	echo "  $0 <bigvideo> <smallvideo> <debug level>"
	exit
fi

if [ -z "$3" ]; then
	DEBUGLVL=0
else
	DEBUGLVL=$2
fi

BIGVID=$1
SMALLVID=$2
OUTFILE="$(basename $BIGVID)_$(basename $SMALLVID)_combined.mp4"

# h264 bitrate
# http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-ugly-plugins/html/gst-plugins-ugly-plugins-x264enc.html#GstX264Enc--bitrate
BITRATE=5120
# 5Mbit/s seems to be recommended

echo "--------"
echo "Merging videos:"
echo "- big: $BIGVID"
echo "- small: $SMALLVID"
echo "- audio is from $SMALLVID"
echo "--------"


gst-launch-1.0 \
  filesrc location=$SMALLVID ! decodebin name=smallvid \
  ! videoscale ! video/x-raw,width=480,height=360 \
  ! videobox name=cambox border-alpha=0 top=-720 left=-1440 ! vidmix. \
  filesrc location=$BIGVID ! decodebin name=bigvid \
  ! progressreport ! videoscale ! video/x-raw,width=1440,height=1080 \
  ! videobox name=screenbox border-alpha=0 top=0 left=0 ! vidmix. \
  videomixer name=vidmix ! videoscale ! x264enc bitrate=$BITRATE ! outmux. \
  bigvid. ! audioconvert ! voaacenc ! outmux. \
  mp4mux name=outmux ! filesink location=$OUTFILE \
  --gst-debug-level=$DEBUGLVL 

  
echo "--------"
echo "Saved video to $OUTFILE"
echo "--------"
  
 
