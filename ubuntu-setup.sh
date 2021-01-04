#!/bin/bash -eu
sudo apt install software-properties-common apt-transport-https curl ca-certificates

# add git repo
sudo add-apt-repository ppa:git-core/ppa

# add latest cmake repo
# wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | sudo apt-key add -
# sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

# add chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# add vscode repo
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update

sudo apt install cmake code git google-chrome-stable docker-ce nvidia-container-toolkit zsh make vim tmux solaar gnome-tweak-tool fcitx-mozc clang-format clang-tidy-10 guake global

# install cuda 10.2
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda cuda-drivers
rm cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb

# cudnn
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt update
sudo apt install libcudnn8 libcudnn8-dev

# install pyenv
sudo apt install -y build-essential libffi-dev libssl-dev zlib1g-dev liblzma-dev libbz2-dev libreadline-dev libsqlite3-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# install pipenv
pip install pipenv

# config docker
sudo gpasswd -a ${USER} docker
sudo chmod 666 /var/run/docker.sock

# latest docker-compose install
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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

# install IDE
sudo snap install clion --classic
sudo snap install pycharm-professional --classic

# fix clock
sudo hwclock -D --systohc --localtime

# purge packages
sudo apt purge apport
