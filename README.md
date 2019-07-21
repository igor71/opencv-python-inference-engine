

## Building from the sources Opencv-Python-Inference-Engine package

It is *Unofficial* pre-built OpenCV+dldt_module package for Python.

`PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.${PY_VER}/site-packages`

**Why:**  
There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt). And you need that module if you want to run models from [Intel's model zoo](https://github.com/opencv/open_model_zoo/).

**Limitations**:
+ Package comes without contrib modules.
+ It was tested on Ubuntu 16.04 & Ubuntu 18.04 with Local Installed Python ver. 3.6.8
+ It is 64 bit.
+ GTK support Enabled.

This package is most similar to `opencv-python-headless`, main differences are:
+ Usage of `AVX512_SKX` instructions
+ No `JPEG 2000`, `WEBP`, `OpenEXR` support
+ `TBB` used as a parallel framework
+ Inference Engine with `MYRIAD` plugin

For additional info read `cv2.getBuildInformation()` output.

## Installing from `pip`

Remove previously installed versions of `cv2`

```bash
pip uninstall opencv-python
```
Install Compailed version:

```bash
pip install dist/opencv_python_inference_engine-4.1.0.*.whl
```

## Known problems and TODOs

#### Steps to compile it with `GTK-2` support (checked)

Make next change in `opencv-python-inference-engine/build/opencv/opencv_setup.sh`:
+ change string `-D WITH_GTK=OFF \`  to `-D WITH_GTK=ON \`

### Versioning

First 3 letters are the version of OpenCV, the last one -- package version. E.g, `4.1.0.2` -- 2nd version of based on 4.1.0 OpenCV package. Package versions are not continuously numbered -- each new OpenCV version starts its own numbering.


## Compiling from source

*I compiled it on Ubuntu 16.04 Linux Docker Container with Python ver. 3.6.8.*
*No Python Virtual ENV were used. Used system $PYTHONPATH*

### Requirements

+ <https://github.com/opencv/dldt/blob/2018/inference-engine/README.md> 
+ <https://docs.opencv.org/4.0.0/d7/d9f/tutorial_linux_install.html> (`build-essential`, `cmake`, `git`, `pkg-config`, `python3-dev`)
+ `python3`
+ `libusb-1.0-0-dev` (for dldt  >= 2019_R1.0.1)
+ `chrpath`

*All above alredy installed inside docker container (see Dockerfile)*

Last successfully tested with dldt-2019_R1.1 & opencv-4.1.0

### Preparing

a. Clone repository on the local server:
```bash
git clone --branch=custom-py-3.6.8-no-ffmpeg --depth=1 https://github.com/igor71/opencv-python-inference-engine
```
b. Build Docker Image & Run It:

```bash
cd opencv-python-inference-engine
 
docker build -f Dockerfile-InferenceEngine-Base -t yi/inference-engine:base .

docker run -it -d --name inference_engine -v /media:/media yi/inference-engine:base

yi-dockeradmin inference_engine
```
c. It is possible to use pre-build docker image as well

```bash
pv /media/common/DOCKER_IMAGES/OpenVINO/yi-inference-engine-base.tar | docker load
docker tag 4ec5f665499d yi/inference-engine:base
docker run -it -d --name inference_engine -v /media:/media yi/inference-engine:base
yi-dockeradmin inference_engine
```

##### Auto Build

```
bash /media/common/DOCKER_IMAGES/Tensorflow/Tflow-VNC-Soft/OpenVINO/build_whl.sh
```

##### Testing Installation
```
python /media/common/DOCKER_IMAGES/Tensorflow/Tflow-VNC-Soft/OpenVINO/TEST/foo.py
```

##### Manual Build Build

```
 mkdir opencv-python-inference-engine && cd opencv-python-inference-engine
 mkdir dldt opencv build
 mkdir -p build/dldt
 mkdir -p build/opencv
 
wget -P $PWD/dldt https://github.com/opencv/dldt/archive/2019_R1.1.tar.gz
pv dldt/2019_R1.1.tar.gz | tar xpzf - -C $PWD/dldt
shopt -s dotglob # Includes filenames beginning with a dot.
mv -- dldt/dldt-2019_R1.1/* dldt/
rm -rf dldt/dldt-2019_R1.1 && rm -f dldt/2019_R1.1.tar.gz

wget -P $PWD/opencv https://github.com/opencv/opencv/archive/4.1.0.tar.gz
pv opencv/4.1.0.tar.gz  | tar xpzf - -C $PWD/opencv
mv -- opencv/opencv-4.1.0/* opencv/
rm -f opencv/4.1.0.tar.gz && rm -rf opencv/opencv-4.1.0

cd dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard 562e301


cd ../../../../build/dldt
sed -i '/add_subdirectory(tests)/s/^/#/g' ../../dldt/inference-engine/CMakeLists.txt
curl -OSL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/OpenVINO/dldt_setup.sh -o $PWD/dldt_setup.sh
bash dldt_setup.sh
make --jobs=$(nproc --all)

cd ../opencv
curl -OSL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/OpenVINO/opencv_setup.sh -o $PWD/opencv_setup.sh
chmod u+x opencv_setup.sh
ABS_PORTION=/opencv-python-inference-engine ./opencv_setup.sh
make --jobs=$(nproc --all)

cd ..
cp -R /media/common/DOCKER_IMAGES/Tensorflow/Tflow-VNC-Soft/OpenVINO/create_wheel/ .
cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/inference-engine/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

chrpath -r '$ORIGIN' create_wheel/cv2/cv2.so
cd create_wheel
python setup.py bdist_wheel
pip install dist/opencv_python_inference_engine-4.1.0.*.whl
``` 

### Reference:
https://github.com/opencv/opencv/wiki/Intel's-Deep-Learning-Inference-Engine-backend
https://github.com/banderlog/opencv-python-inference-engine
