"Dillon Beliveau's .vimrc
"Much smaller than it used to be
"Should automatically install neobundle and all plugins
"when vim is first started. Needs git for NeoBundle.

set encoding=utf-8
set nocompatible
filetype off "Vundle requires filetype off. We turn this back on at the end of the file

set number "Line numbers
set mouse=a "Mouse usage in all modes

nnoremap <SPACE> <Nop>
let mapleader=" "
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

" Searches are case insensitive unless they contain an uppercase letter
" (need both ignorecase and smartcase for this)
set ignorecase
set smartcase

" Identifying tabs, non breakable spaces and trailing spaces.
" exec "set listchars=tab:>~,nbsp:_,trail:\uB7"
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

" Ale settings
let g:ale_completion_enabled = 1
let g:ale_set_balloons = 1
let g:ale_floating_preview = 1
let g:ale_cursor_detail = 1

"Let neobundle update and manage itself
NeoBundleFetch 'Shougo/neobundle.vim'

"Github
NeoBundle 'tpope/vim-sensible'
NeoBundle 'dense-analysis/ale'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'lifepillar/vim-gruvbox8'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
"NeoBundle 'Rykka/riv.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'yegappan/lsp'
NeoBundle 'wincent/terminus'
NeoBundle 'preservim/nerdtree'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

if has("persistent_undo")
    if has("nvim")
        silent !mkdir -p ~/.vim/undodir_nvim > /dev/null 2>&1
        set undodir=~/.vim/undodir_nvim/
    else
        silent !mkdir -p ~/.vim/undodir > /dev/null 2>&1
        set undodir=~/.vim/undodir/
    endif
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

if v:version >= 900
    let lspServers = []
    if executable("clangd") == 1
        let lspServers = lspServers + [#{
            \	  name: 'clang',
            \	  filetype: ['c', 'cpp'],
            \	  path: 'clangd',
            \	  args: ['--background-index']
            \ }]
    endif

    if executable("pyright") == 1
        let lspServers = lspServers + [#{
            \	  name: 'pyright',
            \	  filetype: ['python'],
            \	  path: 'pyright',
            \	  args: ['--watch']
            \ }]
    endif

    if executable("nil") == 1
        let lspServers = lspServers + [#{
            \	  name: 'nil',
            \	  filetype: ['nix'],
            \	  path: 'nil',
            \	  args: ['--stdio']
            \ }]
    endif

    if len(lspServers) > 0
        autocmd VimEnter * call LspAddServer(lspServers)

        let lspOpts = #{ autoHighlightDiags: v:true, aleSupport: v:true, autoHighlight: v:true, showInlayHints: v:true }
        autocmd VimEnter * call LspOptionsSet(lspOpts)
    endif
endif

"Color scheme
syntax enable
set background=dark
colorscheme gruvbox8

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
set wildignore+=*/node_modules/*,*/bower_components/*,*.class,*.o,*/.cache/*,*/.vscode/*,*/.cmake/*,*/CMakeFiles/*

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

"Go to definition with LSP
map gd :ALEGoToDefinition<CR>

" capital K gives help information
nnoremap <s-k> :ALEHover<CR>

" Find usages
nnoremap <leader>fu :ALEFindReferences<CR>

" Reload vimrc
nnoremap <leader>vr :source ~/.vimrc<CR>

filetype plugin on

" Start NERDTree. If a file is specified, move the cursor to its window.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
"
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
