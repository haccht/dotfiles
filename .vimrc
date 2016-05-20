set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,shift-jis,euc-jp

scriptencoding utf-8
filetype off

set t_vb=
set novisualbell
set noerrorbells

set nobackup
set fileformats=unix,dos,mac
setlocal autoindent

set colorcolumn=80
hi ColorColumn guibg=#444444 ctermbg=233

set number
set nowrap

set ignorecase
set incsearch
set hlsearch

if filereadable(expand('~/.vim/local.vim'))
  source $HOME/.vim/local.vim
endif

if &compatible
  set nocompatible
endif

set runtimepath^=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim

" dein settings
call dein#begin(expand('~/.vim/dein/repos/github.com'))
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/unite.vim')
call dein#add('fatih/vim-go')
call dein#add('vim-ruby/vim-ruby')
call dein#add('thinca/vim-quickrun')
call dein#add('glidenote/memolist.vim')
call dein#add('tpope/vim-markdown')
call dein#add('altercation/vim-colors-solarized')
call dein#end()

filetype plugin indent on

" unite settings
let g:unite_enable_start_insert=1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>

" memolist settings
let g:memolist_unite = 1
let g:memolist_memo_suffix = 'md'
let g:memolist_template_dir_path = '~/memo/.template'
nmap <leader>mn :MemoNew<CR>
nmap <leader>ml :MemoList<CR>
nmap <leader>mg :MemoGrep<CR>

" colorscheme
let g:solarized_termcolors=256
set background=dark

syntax enable
colorscheme solarized
