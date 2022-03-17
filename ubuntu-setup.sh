#!/bin/bash -eu
sudo apt install -y software-properties-common apt-transport-https curl ca-certificates

# add git repo
sudo add-apt-repository -y ppa:git-core/ppa

# add github cli repo
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# add chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# add vscode repo
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# add clangd 13 repo
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
sudo add-apt-repository -y "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-13 main"

sudo apt update

sudo apt install -y ssh cmake code git google-chrome-stable docker-ce nvidia-container-toolkit nvidia-container-runtime zsh make vim tmux solaar gnome-tweak-tool fcitx-mozc clang-format clangd-13 guake global python-pip python3-pip htop cifs-utils autofs gh libsecret-1-0 libsecret-1-dev git-lfs network-manager-l2tp-gnome

# config github-cli
gh completion -s zsh > _gh
sudo mv _gh /usr/local/share/zsh/site-functions
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret/
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
gh auth login -w -s write:public_key
ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
gh ssh-key add ~/.ssh/id_rsa.pub
gh auth setup-git

# install cuda 11.3
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda=11.3.1-1
sudo apt-mark hold cuda
rm cuda-repo-ubuntu1804_10.2.89-1_amd64.deb

# cudnn
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install -y ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt update
sudo apt install -y libcudnn7 libcudnn7-dev
rm nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

# install pyenv
sudo apt install -y build-essential libffi-dev libssl-dev zlib1g-dev liblzma-dev libbz2-dev libreadline-dev libsqlite3-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# install pipenv
pip2 install pipenv

# install python-package
pip2 install flake8 pep8-naming flake8-coding flake8-copyright flake8-docstrings flake8-isort flake8-quotes
pip3 install platformio cmake-format isort

# config docker
sudo gpasswd -a ${USER} docker
sudo chmod 666 /var/run/docker.sock
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
EOF
sudo systemctl restart docker

# latest docker-compose install
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# change default shell
chsh ${USER} -s /usr/bin/zsh

# deploy my dotfiles
cd ${HOME}/Documents
gh repo clone dotfiles
cd dotfiles
make init
make deploy
dconf write /org/gnome/shell/favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'gitkraken_gitkraken.desktop']"
dconf load /apps/guake/ < guake.conf

# install neobundle
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install gitkraken
sudo snap install gitkraken --classic

# install slack
sudo snap install slack --classic

# fix clock
sudo hwclock -D --systohc --localtime

# purge packages
sudo apt purge apport

# enable fcitx
im-config -n fcitx

sudo apt purge libomp-10-dev libomp5-10

# NAS config
echo NAS password:
read password
echo "/nas -fstype=cifs,rw,username=admin,password=$password,uid=1000,gid=1000 ://robotics-nas/Public" | sudo tee /etc/auto.nas
sudo sed -i -e "s:^+auto.master$:#+auto.master\n/- /etc/auto.nas --timeout 60:g" /etc/auto.master
sudo service autofs restart
