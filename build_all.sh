!/usr/bin/env bash
CAFFE_USE_MPI=${1:-OFF}
CAFFE_MPI_PREFIX=${MPI_PREFIX:-""}

# update the submodules: Caffe and Dense Flow
git submodule update --remote

# install Caffe dependencies
sudo apt-get -qq install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev
sudo apt-get -qq install --no-install-recommends libboost1.55-all-dev
sudo apt-get -qq install libgflags-dev libgoogle-glog-dev liblmdb-dev


# build caffe
echo "Building Caffe, MPI status: ${CAFFE_USE_MPI}"
cd lib/caffe-action
[[ -d build ]] || mkdir build
cd build
if [ "$CAFFE_USE_MPI" == "MPI_ON" ]; then
OpenCV_DIR=/home/phaihoang/work/temporal-segment-networks/3rd-party/opencv-2.4.13/build/ cmake .. -DUSE_MPI=ON -DMPI_CXX_COMPILER="${CAFFE_MPI_PREFIX}/bin/mpicxx" -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF
else
OpenCV_DIR=/home/phaihoang/work/temporal-segment-networks/3rd-party/opencv-2.4.13/build/ cmake .. -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF
fi
if make -j32 install ; then
    echo "Caffe Built."
    echo "All tools built. Happy experimenting!"
    cd ../../../
else
    echo "Failed to build Caffe. Please check the logs above."
    exit 1
fi
