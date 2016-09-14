" encodings
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,shift-jis,euc-jp
scriptencoding utf-8

" dein settings
if &compatible
  set nocompatible
endif

if isdirectory(expand('~/.vim/dein/repos'))
  set runtimepath^=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim
  call dein#begin(expand('~/.vim/dein'))

  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('fatih/vim-go')
  call dein#add('vim-ruby/vim-ruby')
  call dein#add('thinca/vim-quickrun')
  call dein#add('glidenote/memolist.vim')
  call dein#add('tpope/vim-markdown')
  call dein#add('tomasr/molokai')

  call dein#end()

  syntax on
  colorscheme molokai

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
else
  syntax on
  colorscheme murphy
endif

" global settings
set t_vb=
set novisualbell
set noerrorbells
set laststatus=2
if version > 702
  set noundofile
endif

set nobackup
set fileformats=unix,dos,mac
setlocal autoindent

set background=dark
if version > 702
  set colorcolumn=80
  hi ColorColumn guibg=#444444 ctermbg=233
endif

set number
set nowrap

set ignorecase
set incsearch
set hlsearch

" local settings
if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif

filetype plugin indent on
