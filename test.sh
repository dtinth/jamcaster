#!/bin/bash -e
docker build -t jamcaster . && docker run -ti --rm --init --env-file=.env jamcaster