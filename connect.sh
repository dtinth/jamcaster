#!/bin/bash
while true
do
  sleep 1
  jack_connect 'Jamulus icecaster:output left' icecaster:input_1
  jack_connect 'Jamulus icecaster:output right' icecaster:input_2
done