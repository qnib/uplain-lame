# uplain-lame
Lame installed on top of Ubuntu

## Benchmark

This image uses lame with different `-march` parameter to encode a wav file into mp3.

For the benchmark a c5n.xlarge instance is used.

```
$ lscpu
...
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Platinum 8124M CPU @ 3.00GHz
Stepping:            4
CPU MHz:             3557.011
...
```

The benchmark is slightly faster from the `haswell` micro-architecture onwards.

```
$ ./bench.sh
>> Create input-volume and copy 3600s wav-sample
>>> docker volume create input
input
>>> docker run -ti --rm -v input:/input/ qnib/white-noise:3600s cp /opt/white-3600s.wav /input/white-3600s.wav
> Run different encodings
       qnib/uplain-lame:core2.2019-07-12: /input/white-3600s.wav -> 34 seconds
     qnib/uplain-lame:nehalem.2019-07-12: /input/white-3600s.wav -> 33 seconds
 qnib/uplain-lame:sandybridge.2019-07-12: /input/white-3600s.wav -> 33 seconds
   qnib/uplain-lame:ivybridge.2019-07-12: /input/white-3600s.wav -> 33 seconds
     qnib/uplain-lame:haswell.2019-07-12: /input/white-3600s.wav -> 31 seconds
     qnib/uplain-lame:skylake.2019-07-12: /input/white-3600s.wav -> 31 seconds
      qnib/uplain-lame:znver1.2019-07-12: /input/white-3600s.wav -> 31 seconds
```