FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y git wget openjdk-8-jdk ant gcc libz-dev vim && rm -rf /var/lib/apt/lists/*
RUN cd /root && git clone https://github.com/openstreetmap/mkgmap.git && cd mkgmap && ant
RUN cd /root && git clone https://github.com/openstreetmap/splitter.git && cd splitter && ant
RUN cd /root && wget http://m.m.i24.cc/osmconvert.c && gcc osmconvert.c -lz -O2 -o osmconvert
RUN cd /root && wget http://m.m.i24.cc/osmfilter.c && gcc osmfilter.c -O2 -o osmfilter
RUN cd /root && wget http://m.m.i24.cc/osmupdate.c && gcc osmupdate.c -O2 -o osmupdate
ADD automap.sh /root/automap.sh
