call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/goyo.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Git config
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'gioele/vim-autoswap'
Plug 'davidhalter/jedi-vim', { 'for': 'python'}
Plug 'stephpy/vim-yaml', { 'for': 'yaml'}
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/restore_view.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine'

" Alternative to CtrlP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


Plug 'airblade/vim-rooter'

Plug 'ea2809/behave.vim'

" Coc completion
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

if has("nvim")
		Plug 'SirVer/ultisnips'
		Plug 'honza/vim-snippets'
else
		Plug 'Valloric/YouCompleteMe'
endif

Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'
Plug 'sbdchd/vim-run'
Plug 'tpope/vim-eunuch'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-vinegar'
Plug 'thaerkh/vim-workspace'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'vifm/vifm.vim'"

call plug#end()




" Old completion configuration
" Plug 'zchee/deoplete-jedi', { 'for': 'python'}
" Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
" Plug 'autozimu/LanguageClient-neovim', {
" 			\ 'branch': 'next',
" 			\ 'do': 'bash install.sh',
" 			\ }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java'}
