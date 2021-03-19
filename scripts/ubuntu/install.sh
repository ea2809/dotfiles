# Basic install
sudo apt-get update
sudo apt-get install -y build-essential curl file git
sudo apt-get install -y zsh tmux ripgrep fzy npm python3-pip fd-find

# Change shell
user=$(whoami)
sudo chsh -s /bin/zsh "$user"

# Install snap packages
sudo snap install batcat
sudo snap install nvim --edge --classic
sudo snap install go --classic

# Hand install packages with problems
curl https://github.com/tree-sitter/tree-sitter/releases/tag/v0.19.4 -o $HOME/.local/bin/tree-sitter && chmod u+x $HOME/.local/bin/tree-sitter
curl -L https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -o lsd.deb && sudo dpkg -i lsd.deb

# Diff so fancy install
bash ~/dotfiles/scripts/global/diff-so-fancy.sh

# Install other packages
pip3 install virtualenv
npm install --global yarn neovim
