#!/bin/bash -e
node src/generate-config > /tmp/config.ini
exec jamulus --nogui -c $JAMULUS_SERVER -i /tmp/config.ini --clientname icecaster --mutemyown -j --jsonrpcport 22100