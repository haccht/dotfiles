filetype plugin indent on
set autoread

if &compatible
  set nocompatible
endif

" color settings
syntax on
try
  colorscheme molokai
  set background=dark
  set cursorline
catch
  colorscheme murphy
  set background=dark
  set cursorline
endtry

" encodings
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,shift-jis,euc-jp
set fileformats=unix,dos,mac
scriptencoding utf-8

" encrypt
if has('crypt-blowfish2')
  set cryptmethod=blowfish2
endif

" global settings
set t_vb=
set novisualbell
set noerrorbells

set number
set nowrap
set nobackup
set clipboard=unnamed

set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent
set smartindent
set wildmenu
set lazyredraw

set ignorecase
set smartcase
set incsearch
set hlsearch

set laststatus=2
set showmode
set showcmd
set ruler

let mapleader=','

" :W sudo save file
command W w !sudo tee % > /dev/null

" unite settings
let g:unite_enable_start_insert=1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>

" local settings
if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif
