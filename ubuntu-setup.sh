#!/bin/bash -eu
sudo apt install -y software-properties-common apt-transport-https curl ca-certificates

# add git repo
sudo add-apt-repository -y ppa:git-core/ppa

# add github cli repo
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# add chrome repo
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

# add vscode repo
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg > /dev/null
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

# add clangd 15 repo
curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/llvm-snapshot.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/llvm-snapshot.gpg] http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-15 main" | sudo tee /etc/apt/sources.list.d/llvm.list > /dev/null

sudo apt update

sudo apt install -y ssh cmake code git google-chrome-stable docker-ce nvidia-container-toolkit nvidia-container-runtime docker-compose-plugin zsh make vim tmux solaar gnome-tweak-tool fcitx-mozc fcitx-imlist clang-format clangd-15 guake global python3-pip htop cifs-utils autofs gh libsecret-1-0 libsecret-1-dev git-lfs network-manager-l2tp-gnome apt-rdepends

sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 1

# config github-cli
gh completion -s zsh > _gh
sudo mv _gh /usr/local/share/zsh/site-functions
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret/
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
gh auth login -w -s write:public_key -s write:gpg_key
ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
gh ssh-key add ~/.ssh/id_rsa.pub
gh auth setup-git

# install cuda 11.3
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-11-6 libcudnn8 libcudnn8-dev
sudo apt-mark hold cuda-11-6
rm cuda-keyring_1.0-1_all.deb

# install pyenv
sudo apt install -y build-essential libffi-dev libssl-dev zlib1g-dev liblzma-dev libbz2-dev libreadline-dev libsqlite3-dev
gh repo clone pyenv/pyenv ~/.pyenv

# install pipenv
pip3 install pipenv

# install python-package
pip3 install flake8 pep8-naming flake8-coding flake8-copyright flake8-docstrings flake8-isort flake8-quotes  platformio cmake-format isort

# install rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh

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

# change default shell
chsh ${USER} -s /usr/bin/zsh

# deploy my dotfiles
cd ${HOME}/Documents
gh repo clone dotfiles
cd dotfiles
make init
make deploy
dconf write /org/gnome/shell/favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop']"
dconf load /apps/guake/ < guake.conf

# gpg key config
gpg --gen-key
gpg -a --export "tatsuro.sakaguchi@g.softbank.co.jp" > ~/.gnupg/pubkey.gpg
(echo trust &echo 5 &echo y &echo quit) | gpg --command-fd 0 --edit-key "tatsuro.sakaguchi@g.softbank.co.jp"
gh gpg-key add ~/.gnupg/pubkey.gpg
id=`gpg --list-keys tatsuro.sakaguchi@g.softbank.co.jp | head -2 | tail -1 | tr -d ' '`
git config --global user.signingkey ${id}

# GUI settings
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 28
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans CJK JP Bold 12'
gsettings set org.gnome.desktop.interface font-name 'Noto Sans CJK JP 11'
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans CJK JP 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'SauceCodePro NF Medium 15'

# install neobundle
mkdir -p ~/.vim/bundle
gh repo clone Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# install fzf
gh repo clone junegunn/fzf ~/.fzf -- --depth 1
~/.fzf/install

curl -sSL https://install.python-poetry.org | python3 -
poetry config virtualenvs.in-project true

# install direnv
curl -sfL https://direnv.net/install.sh | bash

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
fcitx &
fcitx-imlist -e mozc

sudo apt purge libomp-10-dev libomp5-10

# NAS config
echo NAS password:
read password
echo "/nas -fstype=cifs,rw,username=admin,password=$password,uid=1000,gid=1000 ://robotics-nas/Public" | sudo tee /etc/auto.nas
sudo sed -i -e "s:^+auto.master$:#+auto.master\n/- /etc/auto.nas --timeout 60:g" /etc/auto.master
sudo service autofs restart
