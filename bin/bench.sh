#!/bin/bash

for x in $(find /input/ -name "*.wav");do
    start=$(date +%s)
    lame -V0 ${x} $(echo ${x} |sed -e 's/wav$/mp3/' |sed -e 's/input/output/') 1>/dev/null 2>/dev/null
    end=$(date +%s)
    echo "${x} -> $((${end}-${start})) seconds"
done