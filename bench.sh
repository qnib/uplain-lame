#!/bin/bash

if [[ $(docker volume ls -q|grep -c '^input$') -eq 0 ]];then
    echo ">> Create input-volume and copy 3600s wav-sample"
    echo ">>> docker volume create input"
    docker volume create input
    echo ">>> docker run -ti --rm -v input:/input/ qnib/white-noise:3600s cp /opt/white-3600s.wav /input/white-3600s.wav"
    docker run -ti --rm -v input:/input/ qnib/white-noise:3600s cp /opt/white-3600s.wav /input/white-3600s.wav
fi
MARCHS="core2,nehalem,sandybridge,ivybridge,haswell,skylake,znver1"
echo "> Run different encodings"
for x in $(echo ${MARCHS} |sed -e 's/,/ /g');do
	printf "%40s: " qnib/uplain-lame:${x}.2019-07-12 
    docker run -e SKIP_ENTRYPOINTS=true -e QUIET_ENTRYPOINT=true -ti --rm -v input:/input/ qnib/uplain-lame:${x}.2019-07-12
done
