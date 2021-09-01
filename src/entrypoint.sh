#!/bin/bash -e

: ${JAMULUS_SERVER:?"Missing required environment variable JAMULUS_SERVER"}
cp ./src/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

if [ -n "$DEV_MODE" ]
then
  echo "Sleeping infinitely."
  sleep infinity
elif [ -n "$VIDEO_STREAM_TARGET" ]
then
  # Video mode
  cp ./src/supervisor-video.conf /etc/supervisor/conf.d/video.conf
  exec xvfb-run -e /dev/stderr -f /tmp/xauth --server-args="-screen 0 1280x720x24" supervisord
else
  # Audio mode
  : ${ICECAST_MOUNT_POINT:?"Missing required environment variable ICECAST_MOUNT_POINT"}
  exec supervisord
fi