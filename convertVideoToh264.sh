#!/bin/sh

# inspiration from :
# http://stackoverflow.com/questions/28036830/how-to-use-gstreamer-for-transcoding-and-resizing-from-mp4h264-aac-to-mp4h264

if [ -z "$1" ]; then
	echo "usage"
	echo "  $0 <filename> <debug level>"
	exit
fi

if [ -z "$2" ]; then
	DEBUGLVL=0
else
	DEBUGLVL=$2
fi

INNAME=$1
OUTNAME="$INNAME.mp4"

# h264 bitrate
# http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-ugly-plugins/html/gst-plugins-ugly-plugins-x264enc.html#GstX264Enc--bitrate
BITRATE=5120
# 5Mbit/s seems to be recommended

# pipeline
#   decode whatever and send it to "bin"
#   encode audio to aac using voaacenc and send to outmux
#   encode video to h264 using x264enc and send to outmux

gst-launch-1.0 filesrc location=$INNAME ! decodebin name=bin \
  bin. ! progressreport \
  ! videoscale ! x264enc bitrate=$BITRATE ! queue ! outmux. \
  bin. ! audioconvert ! voaacenc ! outmux. \
  mp4mux name=outmux ! filesink location=$OUTNAME \
  --gst-debug-level=$DEBUGLVL
  
echo "Saved stream to $OUTNAME"
  
 
