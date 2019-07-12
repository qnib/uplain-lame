#!/bin/bash

MARCHS="core2,nehalem,sandybridge,ivybridge,haswell,skylake,znver1"
for x in $(echo ${MARCHS} |sed -e 's/,/ /g');do
	printf "%40s: " qnib/uplain-lame:${x}.2019-07-12 
    docker run -e SKIP_ENTRYPOINTS=true -e QUIET_ENTRYPOINT=true -ti --rm -v /data/input:/input qnib/uplain-lame:${x}.2019-07-12
done
