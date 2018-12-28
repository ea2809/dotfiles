call plug#begin('~/.vim/plugged')

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
" Plug 'avanzzzi/behave.vim'
" Plug 'rooprob/vim-behave'

if has("nvim")
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
		Plug 'zchee/deoplete-go', { 'do': 'make'}
		Plug 'SirVer/ultisnips'
		" Snippets are separated from the engine.
		Plug 'honza/vim-snippets'
		Plug 'zchee/deoplete-jedi', { 'for': 'python'}
		Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
else
		Plug 'Valloric/YouCompleteMe'
endif
Plug 'sbdchd/neoformat'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java'}
Plug 'neomake/neomake'
Plug 'sbdchd/vim-run'
Plug 'tpope/vim-eunuch'
call plug#end()
