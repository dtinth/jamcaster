#!/bin/bash -e
exec ffmpeg -f jack -ac 2 -i icecaster -acodec libmp3lame -ab 128k -f mp3 $ICECAST_MOUNT_POINT