call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries'}
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
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/restore_view.vim'

if has("nvim")
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
		Plug 'SirVer/ultisnips'
		" Snippets are separated from the engine.
		Plug 'honza/vim-snippets'
		Plug 'zchee/deoplete-jedi', { 'for': 'python'}
		Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
else
		Plug 'Valloric/YouCompleteMe'
endif

call plug#end()
