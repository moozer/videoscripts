#!/bin/sh

# inspiration from :
# http://stackoverflow.com/questions/28036830/how-to-use-gstreamer-for-transcoding-and-resizing-from-mp4h264-aac-to-mp4h264

if [ -z "$1" ]; then
	echo "usage"
	echo "  $0 <filename>"
	exit
fi

FILENAME=$1

# pipeline
# decode whatever and send it to "bin"
# encode audio to aac using voaacenc and send to outmux
# encode video to h264 using 

gst-launch-1.0 filesrc location=$FILENAME ! decodebin name=bin \
  bin. ! progressreport \
  ! videoscale ! x264enc bitrate=5120 ! queue ! outmux. \
  bin. ! audioconvert ! voaacenc ! outmux. \
  mp4mux name=outmux ! filesink location=$FILENAME.mp4
  


#~ gst-launch-0.10 ffmux_mp4 name=mux ! \ filesink location=0000.mp4 \ filesrc location=./gain_1.mp4 ! qtdemux name=vdemux vdemux.video_00 ! queue ! ffdec_h264 ! videoscale ! 'video/x-raw-yuv, width=640, height=480' ! x264enc ! queue ! mux. \ filesrc location=./gain_1.mp4 ! qtdemux name=ademux ademux.audio_00 ! ffdec_aac ! lame bitrate=128 ! queue ! mux.
#~ 

