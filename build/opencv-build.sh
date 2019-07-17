#!/bin/bash

cd /opencv-python-inference-engine/build/opencv

###### Change export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH
###### -->> You will need to add absolute paths to .pc files

sed -i '11d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '10 a export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:$PKG_CONFIG_PATH' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

###### Change string -D WITH_GTK=OFF \ to -D WITH_GTK=ON \ ##############################

##### Delete Original line ####################################################

sed -i '48d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

##### Adding Modified Line ##########################################################################

sed -i '47 a \    -D WITH_GTK=ON \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

############################ Configuring to work with local python (ver.3.6.8) ######################

sed -i '15d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '14 a \# grep "6" from "Python 3.6.8"' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '16d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '15 a \PY_VER=`/usr/local/bin/python --version | sed -rn "s/Python .\\.(.)\\..$/\\1/p"`' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '17d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '16 a \PY_LIB_PATH=`find /usr/local/lib -iname libpython3.${PY_VER}m.so`' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '23d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '22 a \    -D PYTHON3_EXECUTABLE=`which python3.6` \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '25d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '24 a \    -D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=/usr/local/lib/python3.${PY_VER}/site-packages/numpy/core/include \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '26d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '25 a \    -D PYTHON_DEFAULT_EXECUTABLE=`which python3.6` \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '27d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '26 a \    -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.${PY_VER}/site-packages \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '28d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '27 a \    -D PYTHON3_PACKAGES_PATH=/usr/local/include/python3.${PY_VER}m \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh

ABS_PORTION=/opencv-python-inference-engine ./opencv_setup.sh

make --jobs=$(nproc --all)
