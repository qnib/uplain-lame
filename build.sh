#!/bin/bash

DATE=$(date +%F)
MARCHS="core2,nehalem,sandybridge,ivybridge,haswell,skylake,znver1"
NUM_THREADS=$(lscpu -J |jq -r '.lscpu[] | select(.field=="CPU(s):")|.data')
echo ">> Use NUM_THREADS=${NUM_THREADS}"
for x in $(echo ${MARCHS} |sed -e 's/,/ /g');do
  docker build -t qnib/uplain-lame:build-${x}.${DATE} --target=build \
               --build-arg=CFLAGS_MARCH=${x} \
		           --build-arg=NUM_THREADS=${NUM_THREADS} .
  docker build -t qnib/uplain-lame:${x}.${DATE} \
               --build-arg=CFLAGS_MARCH=${x} \
		           --build-arg=NUM_THREADS=${NUM_THREADS} .
  if [[ "X$1" == "Xpush" ]];then
    docker push qnib/uplain-lame:${x}.${DATE}
  fi
done