"Dillon Beliveau's .vimrc
"Much smaller than it used to be
"Should automatically install neobundle and all plugins
"when vim is first started. Needs git for NeoBundle.

set encoding=utf-8
set nocompatible
filetype off "Vundle requires filetype off. We turn this back on at the end of the file

set number "Line numbers
set mouse=a "Mouse usage in all modes

let mapleader=","
let localleader="\\"
set showcmd

set cursorline

"No word wrap
set nowrap

set tabstop=4
set shiftwidth=4
set expandtab

set modeline
set modelines=5

" Identifying tabs, non breakable spaces and trailing spaces.
exec "set listchars=tab:>~,nbsp:_,trail:\uB7"
set list

"Aliases
:command FormatJSON %!python -m json.tool

let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim.git ~/.vim/bundle/neobundle.vim
endif

if has("win32") || has("win16")
    "correct temp directory for swap files (for windows, the defaults on
    "windows are c:\tmp and c:\temp for some reason)
    set directory=.,$TEMP
    "Change working directory (windows)
    set rtp+=~/vimfiles/bundle/neobundle.vim
    call neobundle#begin(expand('~/vimfiles/bundle/'))
else
    "Change working directory (*NIX)
    set rtp+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
endif

"Let neobundle update and manage itself
NeoBundleFetch 'Shougo/neobundle.vim'

"Github
NeoBundle 'tpope/vim-sensible'
NeoBundle 'dense-analysis/ale'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'Rykka/riv.vim'
NeoBundle 'airblade/vim-gitgutter'

if has("persistent_undo")
    silent !mkdir -p ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir/
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

NeoBundle 'mattn/emmet-vim'

"vim-scripts
NeoBundle 'L9'

let g:tex_flavor='latex'

NeoBundleCheck
call neobundle#end()

"Color scheme
syntax enable
set background=dark
colorscheme elflord

if has('gui_running')
    set guioptions-=T  "remove toolbar
    set guioptions-=m  "remove menus
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
else
endif

" Airline configuration

" clock
let g:airline_section_b = '%{strftime("%c")}'
" use powerline fonts
let g:airline_powerline_fonts = 0
" smarter tab line
let g:airline#extensions#tabline#enabled = 1


" Ignore certain directories (comma separated list)
set wildignore+=*/node_modules/*,*/bower_components/*,*.class,*.o

" Fix editing crontab on MacOS
autocmd filetype crontab setlocal nobackup nowritebackup

"Key Bindings

"Pop up list of all files in current dir
map <leader>o :CtrlP<CR>

"Pop up list of all open buffers
map <leader>p :CtrlPBuffer<CR>

"Close current buffer
map <leader>w :bdelete<CR>

"Open new tab
map <leader>t :tabnew<CR>

"Go to next buffer
map <C-tab> :tabnext<CR>
map <leader>l :tabnext<CR>

"Go to previous tab
map <leader>h :tabprevious<CR>

"Browse current directory
map <leader>bd :Explore<CR>

filetype plugin on
