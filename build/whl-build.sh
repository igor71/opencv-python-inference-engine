#!/bin/bash

BUILD_DIR=/opencv-python-inference-engine

cd $BUILD_DIR

cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/inference-engine/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

cp build/ffmpeg/binaries/lib/*.so create_wheel/cv2/

chrpath -r '$ORIGIN' create_wheel/cv2/cv2.so

cd create_wheel

python setup.py bdist_wheel

pip install dist/opencv_python_inference_engine-4.1.0.*.whl

OPCVIE=$(find /tmp/opencv-python-inference-engine/create_wheel/dist  -printf "%f\n")

WHL=$( echo $OPCVIE | cut -d' ' -f2)

echo "$WHL installed correctly!! Locate package at $BUILD_DIR/create_wheel/dist directory"
