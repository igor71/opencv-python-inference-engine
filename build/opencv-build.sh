#!/bin/bash

cd /opencv-python-inference-engine/build/opencv

###### Change export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH
###### -->> You will need to add absolute paths to .pc files

sed -i '11d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '11 a export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:$PKG_CONFIG_PATH' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

###### Change string -D WITH_GTK=OFF \ to -D WITH_GTK=ON \ ##############################

##### Delete Original line ####################################################

sed -i '48d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

##### Adding Modified Line ##########################################################################

sed -i '47 a \    -D WITH_GTK=ON \\' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

############################ Configuring to work with local python (ver.3.6.8) ######################

sed -i '15d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '14 a \# grep "6" from "Python 3.6.8"' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '16d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '15 a \PY_VER=`/usr/local/bin/python --version | sed -rn "s/Python .\\.(.)\\..$/\\1/p"`' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '17d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '16 a \PY_LIB_PATH=`find /usr/lib/x86_64-linux-gnu -iname libpython3.${PY_VER}m.so`' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '23d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '22 a \    -D PYTHON3_EXECUTABLE=`which python3.6` \\' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '25d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '24 a \    -D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=/usr/local/lib/python3.${PY_VER}/dist-packages/numpy/core/include \\' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '26d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '25 a \    -D PYTHON_DEFAULT_EXECUTABLE=`which python3.6` \\' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '27d' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

sed -i '26 a \    -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.${PY_VER}/dist-packages \\' /tmp/opencv-python-inference-engine/build/opencv/opencv_setup.sh

ABS_PORTION=/tmp/opencv-python-inference-engine ./opencv_setup.sh

make --jobs=$(nproc --all)
