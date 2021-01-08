#!/bin/bash -eu
# sudo apt install software-properties-common apt-transport-https curl ca-certificates

# add git repo
sudo add-apt-repository ppa:git-core/ppa

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

sudo apt update

sudo apt install -y git docker-compose zsh solaar fcitx-mozc htop make

# install pyenv
# sudo apt install -y build-essential libffi-dev libssl-dev zlib1g-dev liblzma-dev libbz2-dev libreadline-dev libsqlite3-dev
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# install pipenv
# pip install pipenv

# config docker
sudo gpasswd -a ${USER} docker
sudo chmod 666 /var/run/docker.sock
cat <<EOF > /etc/docker/daemon.json
{
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
EOF

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

echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0666"' | sudo tee /etc/udev/rules.d/10-vchiq-permissions.rules
wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip
unzip PX-S1UD_driver_Ver.1.0.1.zip
sudo cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/
rm -r PX-S1UD_driver_Ver.1.0.1*

git clone https://github.com/l3tnun/EPGStation.git
cd docker-mirakurun-epgstation-rpi
docker-compose build
