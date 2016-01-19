#!/bin/sh

if [ -z "$2" ]; then
	echo "Replaces audio part of the video"
	echo "usage"
	echo "  $0 <filename> <audiofile> <debug level>"
	exit
fi

if [ -z "$3" ]; then
	DEBUGLVL=0
else
	DEBUGLVL=$2
fi

INVIDNAME=$1
INAUDIONAME=$2
OUTVIDNAME="$(basename $2)-$(basename $1)"
BITRATE=5120

echo "--------"
echo "Replacing audio from $INVIDNAME"
echo "  with audio from $INAUDIONAME"
echo "--------"


# pipeline
#   decode whatever video supplied and send it to "vid"
#   decode whatever audio (might be a video with audio) supplied and send it to "aud"
#   encode audio to aac using voaacenc 
#       and ecode video to h264 
#       and send to file

gst-launch-1.0 \
  filesrc location=$INVIDNAME ! decodebin name=vid \
  vid. ! videoconvert ! x264enc bitrate=$BITRATE ! outmux. \
  filesrc location=$INAUDIONAME ! decodebin name=aud \
  aud. ! progressreport ! audioconvert ! voaacenc ! outmux. \
  mp4mux name=outmux ! filesink location=$OUTVIDNAME \
  --gst-debug-level=$DEBUGLVL
  
echo "--------"
echo "Saved audio to $OUTVIDNAME"
echo "--------"
  
 
