filetype plugin indent on

set nocompatible

" encodings
if has('vim_starting')
  set encoding=utf-8
  set termencoding=utf-8
  set fileencodings=utf-8
  set fileformats=unix,dos,mac
endif
scriptencoding utf-8

" encrypt
if has('crypt-blowfish2')
  set cryptmethod=blowfish2
endif

" appearance
set ambiwidth=double
set laststatus=2
set showmatch
set showmode
set showcmd
set ruler
set wildmenu
set lazyredraw
set hidden
set number
set nowrap
set autoread
set smarttab
set wildmenu

" indent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set breakindent
set smartindent
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

" global
set t_vb=
set novisualbell
set noerrorbells
set clipboard=unnamed
set backup
set backupdir=$HOME/.vim/backup
set undofile
set undodir=$HOME/.vim/undo

set pastetoggle=<F10>

" colors
syntax on
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
set background=dark
set cursorline
hi clear CursorLine
try
  colorscheme molokai
catch
  colorscheme murphy
endtry

" mapping
let mapleader=','
noremap ; :
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

" plugins
let g:unite_enable_start_insert=1
nnoremap <silent> <Leader>uy :<C-u>Unite history/yank<CR>
nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Leader>uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> <leader>ur :<C-u>Unite -buffer-name=register register<CR>

let g:quickrun_config={'_': {'split': ''}}
set splitbelow
set splitright

let g:gitgutter_enabled = 0
map <Leader>g :GitGutterToggle<CR>

let g:go_version_warning = 0

" local settings
if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif
