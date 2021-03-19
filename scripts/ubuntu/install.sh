sudo apt-get update
sudo apt-get install -y build-essential curl file git
sudo apt-get install -y zsh tmux bat ripgrep fzy

sudo snap install lsd
bash ~/dotfiles/scripts/global/diff-so-fancy.sh
chsh -s /bin/zsh enrique
