gstreamer scripts readme
=========================


This is a collection of gstreamer based scripts that I find relevant for my presentations.

They use gstreamer 1.0


Install gstreamer 1.0
----------------------

Just install all the plugin packages

    apt-get install \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools \


The scripts
------------

Most of them have usage info if you run them without parameters.

The debug level mentionen is the gstreamer debug level as described in [the docs](http://gstreamer.freedesktop.org/data/doc/gstreamer/head/manual/html/section-checklist-debug.html)

Default is 0, ie. no debug. If you need more info, start at 1 - higher number quickly ends up with ridiculous amount of debug info.


convertVideoToh264.sh
---------------------

Converts whatever [decodebin](http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-base-plugins/html/gst-plugins-base-plugins-decodebin.html) can handle and saves it as h264/aac with a 5Mbit/s bitrate


extractsAudio.sh
---------------------

Decodes the video, and saves the audio stream as an aac file.


