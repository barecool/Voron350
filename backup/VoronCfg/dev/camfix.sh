#!/bin/sh
 
### BEGIN INIT INFO
# Provides:          camera
# Required-Start:    $local_fs networking moonraker klipper
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Camera Settings
# Description:       Sets UVC control settings for camera on boot
### END INIT INFO
 
uvcdynctrl -s 'Focus, Auto' 0
uvcdynctrl -s 'Sharpness' 128
uvcdynctrl -s 'White Balance Temperature' 4000
uvcdynctrl -s 'White Balance Temperature, Auto' 0
uvcdynctrl -s 'White Balance Temperature' 4000
uvcdynctrl -s 'Contrast' 128
uvcdynctrl -s 'Brightness' 128
uvcdynctrl -s 'Focus (absolute)' 29
# uvcdynctrl -s 'Power Line Frequency' 2
 
exit 0