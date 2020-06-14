call plug#begin('~/.vim/plugged')
" Git config
Plug 'tpope/vim-fugitive' " Super usefull commands
Plug 'airblade/vim-gitgutter' " Show line status

" Utilities
Plug 'gioele/vim-autoswap' " No more swap files
Plug 'thaerkh/vim-workspace' " Save file you were working on
Plug 'christoomey/vim-tmux-navigator' " Tmux panel change
Plug 'airblade/vim-rooter' " Auto CD to the base folder
Plug 'junegunn/goyo.vim' " No distraction mode
Plug 'sheerun/vim-polyglot' " Improve syntax
Plug 'tpope/vim-repeat' " Repeteat custom commands
Plug 'tpope/vim-commentary' " Comment lines 'gcc'
Plug 'tpope/vim-surround' "Surround words
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sbdchd/neoformat' " Automatic formatter
Plug 'w0rp/ale' " Linting
Plug 'neomake/neomake' " Linting
Plug 'sbdchd/vim-run' " :Run
Plug 'tpope/vim-eunuch' " Adds thingks like Rename, Move
Plug 'vifm/vifm.vim' " Vifm file manager
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Users snippets repository
Plug 'liuchengxu/vim-which-key' " Show actual mapping on screen

" Language
Plug 'stephpy/vim-yaml', { 'for': 'yaml'}
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'ea2809/behave.vim', { 'for': ['python', 'gherkin', 'cucumber']}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'ea2809/java-syntax.vim', { 'for': 'java'}
Plug 'derekwyatt/vim-scala', { 'for': 'scala'}
" Plug 'davidhalter/jedi-vim', { 'for': 'python'} " Improve completion and go to code

" Improve style
Plug 'vim-airline/vim-airline' " Statusline and tabline
Plug 'ryanoasis/vim-devicons' " Tabline icons
Plug 'Yggdroot/indentLine' " Shows tabs in a different line
Plug 'NLKNguyen/papercolor-theme' " Theme
Plug 'junegunn/vim-easy-align' " Align sentences or markdown table
Plug 'luochen1990/rainbow' " Add colors to every marker () {} <>

" Alternative to CtrlP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()
