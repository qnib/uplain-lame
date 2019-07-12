#!/bin/bash

for x in $(find /input/ -name "*.wav");do
    time lame -V0 ${x} $(echo ${x} |sed -e 's/wav$/mp3/' |sed -e 's/input/output/')
done