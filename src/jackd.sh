#!/bin/bash -e
exec jackd --no-realtime -d dummy -p "${JACK_PERIOD:-1024}"
