# thanks to https://gist.github.com/gmolveau/8fcdb5e953bd6c9dad18ecd39b9718a4
path=/usr/bin
cd $HOME 
git clone https://github.com/so-fancy/diff-so-fancy diffsofancy
chmod +x diffsofancy/diff-so-fancy
ln -s "${HOME}/diffsofancy/diff-so-fancy" "${path}/diff-so-fancy"
