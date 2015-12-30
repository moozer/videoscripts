#!/bin/sh

if [ -z "$1" ]; then
	echo "Extracts audio part of the video"
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
AUDIOOUTNAME="$INNAME.m4a"

echo "--------"
echo "Extracting audio from $INNAME"
echo "--------"


# pipeline
#   decode whatever and send it to "bin"
#   encode audio to aac using voaacenc and send to file

gst-launch-1.0 filesrc location=$INNAME ! decodebin name=bin \
  bin. ! progressreport ! audioconvert ! voaacenc \
  ! mp4mux name=outmux ! filesink location=$AUDIOOUTNAME \
  --gst-debug-level=$DEBUGLVL
  
echo "--------"
echo "Saved audio to $AUDIOOUTNAME"
echo "--------"
  
 
