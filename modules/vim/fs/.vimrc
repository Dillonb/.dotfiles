"Dillon Beliveau's .vimrc
"Should automatically install neobundle and all plugins
"when vim is first started. Needs git for neobundle and
"cmake for YouCompleteMe.
"If YouCompleteMe is required, simply run
"touch ~/.ycm_install before starting vim for the first time.
"YouCompleteMe (Only on Linux) can be activated by
"going to ~/.vim/bundle/YouCompleteMe and running
"./install.sh
"Additionally, eclim can be installed with these instructions:
"http://eclim.org/install.html


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
"Always show tab line
" set showtabline=1
set showtabline=0

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

" Windows
if has("win32") || has("win16")
    set guifont=Consolas:h12:cANSI
else
    " Linux and Mac
    if has("unix")
        " Mac
        if system("uname -s") =~ "Darwin"
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
        " Linux
        else
            set guifont=DejaVu\ Sans\ Mono\ 14
        endif
    " Not Windows and not Unix. wut
    else
        set guifont=DejaVu\ Sans\ Mono\ 11
    endif
endif

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

if has("win32") || has("win16")
    "Windows-only plugins
else
    "Plugins for everything else

    "Only get YouCompleteMe if it's wanted
    if filereadable(expand("~/.ycm_install"))
    NeoBundle 'Valloric/YouCompleteMe', {
        \ 'build' : {
            \     'mac' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
            \     'unix' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
            \     'windows' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
            \     'cygwin' : './install.sh --clang-completer --system-libclang --omnisharp-completer'
            \    }
        \ }
        set completeopt-=preview
        NeoBundleLazy 'jeaye/color_coded', {
       \    'build': {
       \        'unix': 'cmake . && make && make install',
       \    },
       \    'autoload': { 'filetypes': ['c', 'cpp', 'objc', 'objcpp'] },
       \    'build_commands': ['cmake', 'make']
       \}
        " Next two options: close preview window automatically
        let g:ycm_autoclose_preview_window_after_completion = 1
        let g:ycm_autoclose_preview_window_after_insertion = 1
        " Don't confirm, just load .ycm_extra_conf.py automatically.
        let g:ycm_confirm_extra_conf = 0
    endif
endif

"Github
NeoBundle 'tpope/vim-sensible'
NeoBundle 'w0rp/ale'

"NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'flazz/vim-colorschemes'
"NeoBundle 'Shougo/vimproc.vim', {
"            \ 'build' : {
"            \     'windows' : 'tools\\update-dll-mingw',
"            \     'cygwin' : 'make -f make_cygwin.mak',
"            \     'mac' : 'make',
"            \     'linux' : 'make',
"            \     'unix' : 'gmake',
"            \    },
"            \ }
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

if has("persistent_undo")
    silent !mkdir -p ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir/
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

if !empty($GOPATH)
    "NeoBundle 'fatih/vim-go'
endif


if v:version < 703
else
    "Plugins that need at least vim 7.3
    "NeoBundle 'myusuf3/numbers.vim'
endif
NeoBundle 'mattn/emmet-vim'

"vim-scripts
NeoBundle 'L9'

let g:tex_flavor='latex'

NeoBundleCheck
call neobundle#end()

"Settings that need plugins

"Let YouCompleteMe and eclim play nice together
let g:EclimCompletionMethod = 'omnifunc'

" for php
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

"Solarized Dark color scheme
syntax enable
set background=dark
"colorscheme solarized
if has('gui_running')
    "colorscheme molokai
    set guioptions-=T  "remove toolbar
    set guioptions-=m  "remove menus
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar

    "windows-like keyboard shortcuts and cursor behavior
    "only in gvim
    "Disabled for now.
    "source $VIMRUNTIME/mswin.vim
    "behave mswin
else
    colorscheme elflord
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

"Go to last tab
map <leader>h :tabprevious<CR>

"Browse current directory
map <leader>bd :Explore<CR>

"Eclim binds

"Re-load .vimrc
map <leader>r :so $MYVIMRC<CR>

filetype plugin on
