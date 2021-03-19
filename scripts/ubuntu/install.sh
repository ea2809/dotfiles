sudo apt-get update
sudo apt-get install -y build-essential curl file git
sudo apt-get install -y zsh tmux ripgrep fzy npm python3-pip

bash ~/dotfiles/scripts/global/diff-so-fancy.sh
sudo chsh -s /bin/zsh enrique

sudo snap install lsd bat
sudo snap install nvim --edge --classic

npm install --global yarn

pip3 install virtualenv
