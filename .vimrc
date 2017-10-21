
filetype plugin indent on
set autoread

" dein settings
if &compatible
  set nocompatible
endif

if isdirectory(expand('~/.vim/dein'))
  set runtimepath^=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim
  call dein#begin(expand('~/.vim/dein'))
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('tomasr/molokai')
  call dein#add('fatih/vim-go')
  call dein#add('vim-ruby/vim-ruby')
  call dein#add('tpope/vim-markdown')
  call dein#add('thinca/vim-quickrun')
  call dein#add('glidenote/memolist.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#end()
else
  echomsg 'dein directory does not exists.'
endif

" color settings
syntax on
try
  colorscheme molokai
catch
  colorscheme murphy
endtry
set background=dark
set cursorline

" encodings
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,shift-jis,euc-jp
set fileformats=unix,dos,mac
scriptencoding utf-8

" global settings
set t_vb=
set novisualbell
set noerrorbells

set number
set nowrap
set nobackup
set clipboard=unnamed,autoselect

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

" memolist settings
let g:memolist_path = '~/memo'
let g:memolist_unite = 1
let g:memolist_memo_suffix = 'md'
let g:memolist_template_dir_path = '~/memo/.template'
nmap <leader>mn :MemoNew<CR>
nmap <leader>ml :MemoList<CR>
nmap <leader>mg :MemoGrep<CR>

" local settings
if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif
