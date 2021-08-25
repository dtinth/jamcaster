#!/bin/bash -e

: ${ICECAST_MOUNT_POINT:?"Missing required environment variable ICECAST_MOUNT_POINT"}
: ${JAMULUS_SERVER:?"Missing required environment variable JAMULUS_SERVER"}

exec supervisord