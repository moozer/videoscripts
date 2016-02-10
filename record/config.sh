# configuration
# camera  values
CAM_H="720"
CAM_W="1280"
CAM_FPS="25/1"
CAM_DEVICE="/dev/v4l/by-id/usb-046d_HD_Pro_Webcam_C920_2B439E1F-video-index0"
CAM_FORMAT="YV12"

# audio
ALSA_DEVICE="C920"

# screencasting
X_FPS="15/1"
#X_FPS="$CAM_FPS"

# x264 encoding
BITRATE=5120
OUT_FPS="$CAM_FPS"
