#!/bin/bash -e

: ${JAMULUS_SERVER:?"Missing required environment variable JAMULUS_SERVER"}

if [ -n "$VIDEO_STREAM_TARGET" ]
then
  # Video mode
  exec xvfb-run --server-args="-screen 0 1280x720x24" supervisord
else
  # Audio mode
  : ${ICECAST_MOUNT_POINT:?"Missing required environment variable ICECAST_MOUNT_POINT"}
  exec supervisord
fi