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
Plug 'tpope/vim-repeat' " Repeteat custom commands
Plug 'tpope/vim-commentary' " Comment lines 'gcc'
Plug 'tpope/vim-surround' "Surround words
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
Plug 'sbdchd/neoformat' " Automatic formatter
Plug 'neomake/neomake' " Linting
Plug 'tpope/vim-eunuch' " Adds thingks like Rename, Move
Plug 'vifm/vifm.vim' " Vifm file manager
Plug 'SirVer/ultisnips' " Snippets
Plug 'honza/vim-snippets' " Users snippets repository
Plug 'folke/which-key.nvim'
Plug 'unblevable/quick-scope' "Show movements to be faster
Plug 'tpope/vim-sleuth' " Detect tabstop and shiftwidth automatically

" Language
Plug 'stephpy/vim-yaml', { 'for': 'yaml'}
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'ea2809/behave.vim', { 'for': ['python', 'gherkin', 'cucumber']}
Plug 'ea2809/java-syntax.vim', { 'for': 'java'}
Plug 'derekwyatt/vim-scala', { 'for': 'scala'}

" Improve style
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons' " Tabline icons
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'junegunn/vim-easy-align' " Align sentences or markdown table

" Plug 'NLKNguyen/papercolor-theme' " Old theme, probably the BEST
Plug 'sainnhe/gruvbox-material' "New theme
Plug 'liuchengxu/vista.vim'

" Alternative to CtrlP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

Plug 'nvim-lua/popup.nvim' " Needed for telescope
Plug 'nvim-lua/plenary.nvim' " Needed for telescope
Plug 'nvim-tree/nvim-web-devicons' " Another devicons ??

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Better Sintax
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'echasnovski/mini.nvim'  " Swissknife

" Latex and others
Plug 'lervag/vimtex'

"Clojure
Plug 'liquidz/elin'
Plug 'liquidz/elin-coc-source'

call plug#end()
