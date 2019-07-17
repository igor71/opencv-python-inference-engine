#!/bin/bash

cd /opencv-python-inference-engine

wget -P $PWD/dldt wget https://github.com/opencv/dldt/archive/2019_R1.1.tar.gz

pv dldt/2019_R1.1.tar.gz | tar xpzf - -C $PWD/dldt

shopt -s dotglob # Includes filenames beginning with a dot.

mv -- dldt/dldt-2019_R1.1/* dldt/

rm -rf dldt/dldt-2019_R1.1 && rm -f dldt/2019_R1.1.tar.gz

wget -P $PWD/opencv https://github.com/opencv/opencv/archive/4.1.0.tar.gz 

pv opencv/4.1.0.tar.gz  | tar xpzf - -C $PWD/opencv

mv -- opencv/opencv-4.1.0/* opencv/

rm -f opencv/4.1.0.tar.gz && rm -rf opencv/opencv-4.1.0

wget -P $PWD/ffmpeg https://github.com/FFmpeg/FFmpeg/archive/n4.1.3.tar.gz 

pv ffmpeg/n4.1.3.tar.gz   | tar xpzf - -C $PWD/ffmpeg

mv -- ffmpeg/FFmpeg-n4.1.3/* ffmpeg/

rm -rf ffmpeg/FFmpeg-n4.1.3 && rm -f ffmpeg/n4.1.3.tar.gz

shopt -u dotglob # Disables previously enabled dotglob option.

echo "All Packages Downloaded and Unpacked Successfully!!!"
