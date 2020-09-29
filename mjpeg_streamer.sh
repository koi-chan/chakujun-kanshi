#!/bin/bash

mjpg_streamer -o "output_http.so -w /usr/local/share/mjpg-streamer/www" -i "input_uvc.so -d /dev/video0 -f 15 -n"
