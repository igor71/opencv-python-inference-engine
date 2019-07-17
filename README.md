

## Building from the sources Opencv-Python-Inference-Engine package

It is *Unofficial* pre-built OpenCV+dldt_module package for Python.

**Why:**  
There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt). And you need that module if you want to run models from [Intel's model zoo](https://github.com/opencv/open_model_zoo/).

**Limitations**:
+ Package comes without contrib modules.
+ It was tested on Ubuntu 16.04 & Ubuntu 18.04 with Local Installed Python ver. 3.6.8
+ It is 64 bit.
+ It built with `ffmpeg` and `v4l` support (`ffmpeg` libs included).
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
Install Compaled version:

```bash
pip install dist/opencv_python_inference_engine-4.1.0.*.whl
```

## Known problems and TODOs

#### Steps to compile it with `GTK-2` support (checked)

Make next changes in `opencv-python-inference-engine/build/opencv/opencv_setup.sh`:
1. change string `-D WITH_GTK=OFF \`  to `-D WITH_GTK=ON \`
2. change `export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH` -- you will need to
   add absolute paths to `.pc` files. On Ubuntu 18.04 it were
   `/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:/usr/local/lib/pkgconfig/:/usr/lib/pkgconfig/`

Exporting `PKG_CONFIG_PATH` for `ffmpeg` somehow messes with default values.

### Build `ffmpeg` with `tbb`

Both `dldt` and `opencv` are compiled with `tbb` support, and `ffmpeg` compiled without it -- this does not feels right.
There is some unproved solution for how to compile `ffmpeg` with `tbb` support:
<https://stackoverflow.com/questions/6049798/ffmpeg-mt-and-tbb>  
<https://stackoverflow.com/questions/14082360/pthread-vs-intel-tbb-and-their-relation-to-openmp>

### Versioning

First 3 letters are the version of OpenCV, the last one -- package version. E.g, `4.1.0.2` -- 2nd version of based on 4.1.0 OpenCV package. Package versions are not continuously numbered -- each new OpenCV version starts its own numbering.


## Compiling from source

I compiled it on Ubuntu 16.04 Linux Docker Container with Python ver. 3.6.8.
No Python Virrtual ENV were used. Used system $PYTHONPATH

### Requirements

+ <https://github.com/opencv/dldt/blob/2018/inference-engine/README.md> 
+ <https://docs.opencv.org/4.0.0/d7/d9f/tutorial_linux_install.html> (`build-essential`, `cmake`, `git`, `pkg-config`, `python3-dev`)
+ `nasm` (for ffmpeg)
+ `python3`
+ `libusb-1.0-0-dev` (for dldt  >= 2019_R1.0.1)
+ `chrpath`

All above alredy installed inside docker container (see Dockerfile)

Last successfully tested with dldt-2019_R1.1, opencv-4.1.0, ffmpeg-4.1.3

### Preparing

a. Clone repository on the local server:
```bash
git clone --branch=custom-py-3.6.8 --depth=1 https://github.com/igor71/opencv-python-inference-engine
```
b. Build Docker Image & Run It:

```bash
cd opencv-python-inference-engine
 
docker build -f Dockerfile-InferenceEngine-Base -t yi/inference-engine:base .

docker run -it -d --name inference_engine -v /media:/media yi/inference-engine:base

yi-dockeradmin inference_engine
```
c. Clone repository inside running docker container:

```bash
git clone --branch=custom-py-3.6.8 --depth=1 https://github.com/igor71/opencv-python-inference-engine
```

#### Auto Build Steps

1. Change working directory

```bash
cd /opencv-python-inference-engine/build
```
2. Run download-extract-dir.sh script
```bash
bash download-extract-dir.sh
```
3. Run dependences-install.sh
```bash
bash dependences-install.sh
```
4. Run opencv-build.sh script
```bash
bash opencv-build.sh
```
5. Run whl-build.sh script
```bash
bash whl-build.sh
```
6. Test installed opencv package
```bash
cd TEST
python foo.py
```
Should return following output:
```bash
Success!
[[0.00815217 0.9918479 ]]
```
If needed to check config output, used for compaling opencv, run those commands:
```bash
cd TEST
python opencv_build_info.py
```


### Manual Build Steps


1. Download releases of [dldt](https://github.com/opencv/dldt/releases), [opencv](https://github.com/opencv/opencv/releases) and [ffmpeg](https://github.com/FFmpeg/FFmpeg/releases) (or clone their repos) & unpack archives to `dldt`,`opencv` and `ffmpeg` folders.

```bash
cd opencv-python-inference-engine/
wget -P $PWD/dldt https://github.com/opencv/dldt/archive/2019_R1.1.tar.gz
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
```

2. You'll need to get 3rd party `ade` code for dldt of certain commit (as in original dldt repo):

```bash
cd dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard 562e301
```

### Compilation

`$ABS_PORTION` is a absolute path to `opencv-python-inference-engine` dir.

#####  BUild FFMPEG  

```bash
cd ../../../../build/ffmpeg
./ffmpeg_setup.sh
./ffmpeg_premake.sh
make --jobs=$(nproc --all)
make install
```
######  BUild DLDT  

`cd ../dldt`

NOTE, if you do not want to buld all IE tests --
comment L:142 in `../../dldt/inference-engine/CMakeLists.txt` ("add_subdirectory(tests)") <https://github.com/opencv/dldt/pull/139>

```bash
sed -i '/add_subdirectory(tests)/s/^/#/g' ../../dldt/inference-engine/CMakeLists.txt
./dldt_setup.sh
make --jobs=$(nproc --all)
```
######  BUild OPENCV 

`cd ../opencv`

`Original line --->>>  export PKG_CONFIG_PATH=$FFMPEG_PATH/lib/pkgconfig:$PKG_CONFIG_PATH`

###### change export PKG_CONFIG_PATH in order to work with `GTK-2` support 

```bash
sed -i '11d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh
sed -i '10 a export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:$PKG_CONFIG_PATH' /opencv-python-inference-engine/build/opencv/opencv_setup.sh
```

###### change string -D WITH_GTK=OFF \ to -D WITH_GTK=ON \ 

############# Delete Original line #############

`sed -i '48d' /opencv-python-inference-engine/build/opencv/opencv_setup.sh`

############# Adding Modified Line #############

`sed -i '47 a \    -D WITH_GTK=ON \\' /opencv-python-inference-engine/build/opencv/opencv_setup.sh`

###### Configuring to work with local python (ver.3.6.8)

```bash
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
```
###### Checkinfg Results

`nano /opencv-python-inference-engine/build/opencv/opencv_setup.sh`

##### Perform Build Steps

```bash 
ABS_PORTION=/tmp/opencv-python-inference-engine ./opencv_setup.sh

make --jobs=$(nproc --all)
```

###### Wheel creation & installation

```bash
# get all compiled libs together
cd ../../
cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/inference-engine/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

cp build/ffmpeg/binaries/lib/*.so create_wheel/cv2/

# change RPATH
chrpath -r '$ORIGIN' create_wheel/cv2/cv2.so 

# final .whl will be in /create_wheel/dist/
cd create_wheel
python setup.py bdist_wheel
pip install dist/opencv_python_inference_engine-4.1.0.*.whl
```

### Testing installed opencv package

```bash
cd /opencv-python-inference-engine/build/TEST
python foo.py
```
Should return following output:
```bash
Success!
[[0.00815217 0.9918479 ]]
```
If needed to check config output, used for compaling opencv, run those commands:
```bash
cd /opencv-python-inference-engine/buildTEST
python opencv_build_info.py
```
