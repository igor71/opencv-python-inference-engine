#!/bin/bash

cd /opencv-python-inference-engine/dldt/inference-engine/thirdparty/ade

git clone https://github.com/opencv/ade/ ./

git reset --hard 562e301

###############  BUild FFMPEG  ######################

cd ../../../../build/ffmpeg

bash ffmpeg_setup.sh

bash ffmpeg_premake.sh

make --jobs=$(nproc --all)

make install

###############  BUild DLDT  ######################

cd ../dldt

# If you do not want to buld all IE tests
# comment L:142 in `dldt/inference-engine/CMakeLists.txt` ("add_subdirectory(tests)")

sed -i '/add_subdirectory(tests)/s/^/#/g' ../../dldt/inference-engine/CMakeLists.txt

bash dldt_setup.sh

make --jobs=$(nproc --all)




