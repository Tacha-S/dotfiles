sudo apt install software-properties-common apt-transport-https

sudo add-apt-repository ppa:git-core/ppa

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"


sudo apt update

sudo apt install code git google-chrome-stable zsh make

chsh ${USER} -s /usr/bin/zsh 

cd ${HOME}/Documents
git clone git@github.com:Tacha-S/dotfiles.git
cd dotfiles
make init 
make deploy
