#!/bin/bash -e

# Usage:
# 1. Pull latest docker image (once): docker pull ghcr.io/dtinth/jamcaster:main
# 2. Run: docker run -ti --rm --init -e JAMULUS_CLIENT_NAME=JamRec -v $PWD/private/out:/out ghcr.io/dtinth/jamcaster:main src/capture.sh <IP>:<PORT>
# 3. Recorded MP3 file appears at `private/out/output.mp3`

: ${1:?"Missing Jamulus server IP:PORT"}
JAMULUS_SERVER="$1"

# Start JACK server
jackd --no-realtime -d dummy &
sleep 2

# Start Jamulus
node src/generate-config > /tmp/config.ini
jamulus --nogui -c $JAMULUS_SERVER -i /tmp/config.ini --clientname icecaster &

# Connect to Jack
(
  sleep 2
  jack_connect 'Jamulus icecaster:output left' icecaster:input_1
  jack_connect 'Jamulus icecaster:output right' icecaster:input_2
) &

# Record 10 seconds of audio
ffmpeg -ss 00:00:03 -f jack -ac 2 -t 10 -i icecaster -acodec libmp3lame -ab 128k -f mp3 -y /out/output.mp3