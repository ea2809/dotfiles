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
" Plug 'neoclide/coc.nvim', {'branch': 'release'}  "Problem with coc-java
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'sbdchd/neoformat' " Automatic formatter
" Plug 'w0rp/ale' " Linting
Plug 'neomake/neomake' " Linting
" Plug 'sbdchd/vim-run' " :Run
Plug 'tpope/vim-eunuch' " Adds thingks like Rename, Move
Plug 'vifm/vifm.vim' " Vifm file manager
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Users snippets repository
" Plug 'liuchengxu/vim-which-key' " Show actual mapping on screen
Plug 'folke/which-key.nvim'
" Plug 'ludovicchabant/vim-gutentags' "Take tare of the tags -> Performance problems when there are too many files
" Plug 'psliwka/vim-smoothie' " Better scrolling     -> Not workin as expected parecía normal pero no funcionó nada bien
Plug 'unblevable/quick-scope' "Show movements to be faster

" Language
Plug 'stephpy/vim-yaml', { 'for': 'yaml'}
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'ea2809/behave.vim', { 'for': ['python', 'gherkin', 'cucumber']}
Plug 'ea2809/java-syntax.vim', { 'for': 'java'}
Plug 'derekwyatt/vim-scala', { 'for': 'scala'}
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
" Plug 'davidhalter/jedi-vim', { 'for': 'python'} " Improve completion and go to code    -> Coc is better

" Improve style
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons' " Tabline icons
Plug 'Yggdroot/indentLine' " Shows tabs in a different line
Plug 'junegunn/vim-easy-align' " Align sentences or markdown table
" Plug 'NLKNguyen/papercolor-theme' " Old theme, probably the BEST
Plug 'sainnhe/gruvbox-material' "New theme
Plug 'liuchengxu/vista.vim'

" Alternative to CtrlP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim' " Needed for telescope
Plug 'nvim-lua/plenary.nvim' " Needed for telescope
Plug 'nvim-telescope/telescope.nvim' " Alternative to fzf
Plug 'nvim-telescope/telescope-fzy-native.nvim' " Better sorter
Plug 'nvim-tree/nvim-web-devicons' " Another devicons ??

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Better Sintax
" Plug 'luochen1990/rainbow' " Add colors to every marker () {} <>
" Plug 'p00f/nvim-ts-rainbow'
Plug 'romgrk/nvim-treesitter-context'


Plug 'echasnovski/mini.nvim'  " Swissknife

call plug#end()
