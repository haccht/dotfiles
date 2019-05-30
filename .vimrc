filetype plugin indent on

if &compatible
  set nocompatible
endif

" encodings
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
set ambiwidth=double
scriptencoding utf-8

" encrypt
if has('crypt-blowfish2')
  set cryptmethod=blowfish2
endif

" global settings
set t_vb=
set novisualbell
set noerrorbells

set hidden
set number
set nowrap
set nobackup
set autoread
set smarttab
set wildmenu
set clipboard=unnamed
set pastetoggle=<F10>

set lazyredraw
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

set ignorecase
set smartcase
set incsearch
set hlsearch

set laststatus=2
set showmatch
set showmode
set showcmd
set ruler

" color settings
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

let mapleader=','
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

let g:unite_enable_start_insert=1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>

let g:quickrun_config={'_': {'split': ''}}
set splitbelow
set splitright

let g:gitgutter_enabled = 0
map <Leader>g :GitGutterToggle<CR>

" local settings
if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif
