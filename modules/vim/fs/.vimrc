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
"Exuberant ctags (exuberant-ctags) required for tagbar.


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

"When multiple files are opened, open them all in tabs.
"tab all


"Aliases

:command Jio JavaImportOrganize
:command Of browse confirm e
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

if filereadable(expand("~/.tern_install"))
    NeoBundle 'marijnh/tern_for_vim', { 'build': { 'mac': 'npm install', 'unix': 'npm install' } }
endif

"Github
NeoBundle 'tpope/vim-sensible'

NeoBundle 'majutsushi/tagbar'

NeoBundle 'scrooloose/syntastic'
""NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'flazz/vim-colorschemes'
"NeoBundle 'airblade/vim-gitgutter'
"NeoBundle 'Shougo/vimproc.vim', {
"            \ 'build' : {
"            \     'windows' : 'tools\\update-dll-mingw',
"            \     'cygwin' : 'make -f make_cygwin.mak',
"            \     'mac' : 'make',
"            \     'linux' : 'make',
"            \     'unix' : 'gmake',
"            \    },
"            \ }
"NeoBundle 'Shougo/unite.vim'
NeoBundle 'kien/ctrlp.vim'
"NeoBundle 'tpope/vim-fugitive'
NeoBundle 'bling/vim-airline'
"NeoBundle 'mhinz/vim-startify'
NeoBundle 'othree/html5.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
"NeoBundle 'hail2u/vim-css3-syntax'
"NeoBundle 'justinmk/vim-sneak'
"NeoBundle 'christoomey/vim-tmux-navigator'
"NeoBundle 'tpope/vim-haml'
"NeoBundle 'jceb/vim-orgmode'
NeoBundle 'Yggdroot/indentLine'
"NeoBundle 'pangloss/vim-javascript'
"NeoBundle 'othree/javascript-libraries-syntax.vim'
"NeoBundle 'claco/jasmine.vim'
"NeoBundle 'burnettk/vim-angular'
"NeoBundle 'mbbill/undotree'
"NeoBundle 'rking/ag.vim'
"NeoBundle 'editorconfig/editorconfig-vim'
"NeoBundle 'derekwyatt/vim-scala'
"NeoBundle 'lukaszkorecki/workflowish'

"NeoBundle 'toyamarinyon/vim-swift'

" Clojure Stuff
"NeoBundle 'tpope/vim-classpath'
"NeoBundle 'tpope/vim-fireplace'
"NeoBundle 'tpope/vim-salve'
"NeoBundle 'kien/rainbow_parentheses.vim'
"NeoBundle 'guns/vim-clojure-static'
"NeoBundle 'guns/vim-clojure-highlight'

"autocmd VimEnter *       RainbowParenthesesToggle
"autocmd Syntax   clojure RainbowParenthesesLoadRound
"autocmd Syntax   clojure RainbowParenthesesLoadSquare
"autocmd Syntax   clojure RainbowParenthesesLoadBraces

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
NeoBundle 'gregsexton/MatchTag'

"NeoBundle 'git://drupalcode.org/project/vimrc.git', {'rtp': 'bundle/vim-plugin-for-drupal/'}


if v:version < 703
else
    "Plugins that need at least vim 7.3
    "NeoBundle 'myusuf3/numbers.vim'
endif
NeoBundle 'mattn/emmet-vim'

"vim-scripts
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
" NeoBundle 'django.vim'

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
    colorscheme mopkai
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


" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" Fix editing crontab on MacOS
autocmd filetype crontab setlocal nobackup nowritebackup

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif


"Key Bindings

"Toggle tagbar (needs exuberant ctags)
map <F8> :TagbarToggle<CR>

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

"Add new imports, organize existing ones and remove unused.
map <leader>ji :JavaImportOrganize<CR>
"Run the program.
map <leader>jr :Java<CR>
"Run the current file
map <leader>jcr :Java %<CR>
"Open javadoc for the element under the cursor.
map <leader>jd :JavaDocSearch<CR>

map <leader>jf :FormatJSON<CR>


"Re-load .vimrc
map <leader>r :so $MYVIMRC<CR>

filetype plugin on


"" disable arrow keys to force me to learn hjkl
"inoremap  <Up>     <NOP>
"inoremap  <Down>   <NOP>
"inoremap  <Left>   <NOP>
"inoremap  <Right>  <NOP>
"noremap   <Up>     <NOP>
"noremap   <Down>   <NOP>
"noremap   <Left>   <NOP>
"noremap   <Right>  <NOP>
"

