#!/bin/bash -eu
sudo apt install software-properties-common apt-transport-https

# add git repo
sudo add-apt-repository ppa:git-core/ppa

# add chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# add vscode repo
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

sudo apt update

sudo apt install code git google-chrome-stable zsh make curl vim tmux solaar gnome-tweek-tool fcitx-mozc clang-format

# install nvidia driver
sudo ubuntu-drivers autoinstall

# install cuda 10.2
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
rm cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb



# change default shell
chsh ${USER} -s /usr/bin/zsh

# register ssh key to github
ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
curl -u "Tacha-S" --data '{"title":"'"$(whoami)@$(hostname)"'","key":"'"$(cat ~/.ssh/id_rsa.pub)"'"}' https://api.github.com/user/keys

# deploy my dotfiles
cd ${HOME}/Documents
git clone git@github.com:Tacha-S/dotfiles.git
cd dotfiles
make init
make deploy

# install neobundle
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install gitkraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb

# install slack
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.8.0-amd64.deb
sudo apt install ./slack-desktop-4.8.0-amd64.deb
rm slack-desktop-4.8.0-amd64.deb

# fix clock
sudo hwclock -D --systohc --localtime

# purge packages
sudo apt purge apport

# build opencv 4.2
# sudo apt install build-essential cmake pkg-config unzip yasm git checkinstall \
#                  libjpeg-dev libpng-dev libtiff-dev \
#                  libavcodec-dev libavformat-dev libswscale-dev libavresample-dev \
#                  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
#                  libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev \
#                  libfaac-dev libmp3lame-dev libvorbis-dev \
#                  libopencore-amrnb-dev libopencore-amrwb-dev \
#                  libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils \
#                  libgtk-3-dev \
#                  libtbb-dev \
#                  libatlas-base-dev gfortran \
#                  libprotobuf-dev protobuf-compiler \
#                  libgoogle-glog-dev libgflags-dev \
#                  libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
# cd /usr/include/linux
# sudo ln -s -f ../libv4l1-videodev.h videodev.h
# cd ${HOME}

# wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
# wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip
# unzip opencv.zip
# unzip opencv_contrib.zip


# cd opencv-4.2.0
# mkdir build
# cd build

# cmake -D CMAKE_BUILD_TYPE=RELEASE \
# 	-D CMAKE_C_COMPILER=/usr/bin/gcc-7 \
# -D CMAKE_INSTALL_PREFIX=/usr/local \
# -D INSTALL_PYTHON_EXAMPLES=ON \
# -D INSTALL_C_EXAMPLES=OFF \
# -D WITH_TBB=ON \
# -D WITH_CUDA=ON \
# -D WITH_CUDNN=ON \
# -D OPENCV_DNN_CUDA=ON \
# -D CUDA_ARCH_BIN=6.1 \
# -D BUILD_opencv_cudacodec=OFF \
# -D ENABLE_FAST_MATH=1 \
# -D CUDA_FAST_MATH=1 \
# -D WITH_CUBLAS=1 \
# -D WITH_V4L=ON \
# -D WITH_QT=OFF \
# -D WITH_OPENGL=ON \
# -D WITH_GSTREAMER=ON \
# -D OPENCV_GENERATE_PKGCONFIG=ON \
# -D OPENCV_PC_FILE_NAME=opencv.pc \
# -D OPENCV_ENABLE_NONFREE=ON \
# -D OPENCV_PYTHON3_INSTALL_PATH=~/.virtualenvs/cv/lib/python3.6/site-packages \
# -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.2.0/modules \
# -D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
# -D BUILD_EXAMPLES=ON ..
# make -j8
# sudo make install
# cd ../../
# rm opencv-4.2.0
# rm opencv_contrib-4.2.0
