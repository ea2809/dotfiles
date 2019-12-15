call plug#begin('~/.vim/plugged')

" Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/goyo.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'gioele/vim-autoswap'
Plug 'davidhalter/jedi-vim', { 'for': 'python'}
Plug 'stephpy/vim-yaml', { 'for': 'yaml'}
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/restore_view.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

" Plug 'rust-lang/rust.vim'
" Plug 'avanzzzi/behave.vim'
" Plug 'rooprob/vim-behave'
"
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

if has("nvim")
		" Plug 'zchee/deoplete-jedi', { 'for': 'python'}
		" Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
		" Plug 'autozimu/LanguageClient-neovim', {
		" 			\ 'branch': 'next',
		" 			\ 'do': 'bash install.sh',
		" 			\ }
		" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
		Plug 'SirVer/ultisnips'
		Plug 'honza/vim-snippets'
else
		Plug 'Valloric/YouCompleteMe'
endif
Plug 'sbdchd/neoformat'
" Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java'}
Plug 'neomake/neomake'
Plug 'sbdchd/vim-run'
Plug 'tpope/vim-eunuch'
Plug 'junegunn/vim-easy-align'
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vinegar'
Plug 'thaerkh/vim-workspace'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
call plug#end()
