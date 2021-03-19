path=$HOME/venvs/nvim3
venvs=dirname $path
name=basename $path 

rm -r $path || echo "Does not exists"

echo "Create venv $name at $venvs"
mkdir -p $path
cd $venvs
virtualenv -p python3 $name
source $name/bin/activate
pip install pynvim
