#!/bin/bash -e

if [ -n "$VIDEO_STREAM_TARGET" ]
then
  # Video mode
  exec ffmpeg \
    -f jack -ac 2 -i icecaster \
    -f x11grab -draw_mouse 0 -framerate "${FFMPEG_FRAMERATE:-16}" -video_size 1280x720 -i "$DISPLAY"+0,0 \
    -c:v libx264 -preset ultrafast -b:v 352k \
    -vf "format=yuv420p" -g 60 -c:a aac -b:a 160k -ar 48000 \
    -f flv "$VIDEO_STREAM_TARGET"
else
  # Audio mode
  exec ffmpeg -f jack -ac 2 -i icecaster -acodec libmp3lame -ab 128k -f mp3 "$ICECAST_MOUNT_POINT"
fi