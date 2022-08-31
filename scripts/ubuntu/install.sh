# Basic install
sudo apt-get update
sudo apt-get install -y build-essential curl file git
sudo apt-get install -y zsh tmux ripgrep fzy npm python3-pip fd-find bat

# Fix fdfind binary
sudo ln -s $(which fdfind) /usr/local/bin/fd

# Install yarn
npm install --global yarn

# Change shell
user=$(whoami)
sudo chsh -s /bin/zsh "$user"

# Install snap packages
sudo snap install nvim --edge --classic
sudo snap install go --classic

# Hand install packages with problems
tree_sitter_version=`curl -s https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest | python3  -c 'import sys, json; print(json.load(sys.stdin)["tag_name"])'`
sudo curl https://github.com/tree-sitter/tree-sitter/releases/tag/$tree_sitter_version -o /usr/local/bin/tree-sitter && sudo chmod u+x /usr/local/bin/tree-sitter

# Latest lsd
LSDVERSION=`curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | python3  -c 'import sys, json; print(json.load(sys.stdin)["tag_name"])'`
curl -L https://github.com/Peltoche/lsd/releases/download/${LSDVERSION}/lsd_${LSDVERSION}_amd64.deb -o lsd.deb && sudo dpkg -i lsd.deb

# Magic nvm
NVMVERSION=`curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | python3  -c 'import sys, json; print(json.load(sys.stdin)["tag_name"])'`
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVMVERSION}/install.sh | bash
nvm install --lts # Install latest lts version

# Pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pushd ~/.pyenv && src/configure && make -C src
popd
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH=$PATH:$PYENV_ROOT/bin' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Diff so fancy install
bash ~/dotfiles/scripts/global/diff-so-fancy.sh

# Install other packages
npm install --global yarn neovim
echo "When python is configured"
echo "pushd && mkdir venv && python -m virtualenv nvim3 && source nvim3/bin/activate && pip install pynvim --upgrade && popd" 
echo "pip3 install virtualenv"
