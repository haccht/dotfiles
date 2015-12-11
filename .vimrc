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

if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" NeoBundle settings
call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'fatih/vim-go'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'sjl/badwolf'
call neobundle#end()

filetype plugin indent on
NeoBundleCheck


" badwolf settings
colorscheme badwolf

" unite settings
let g:unite_enable_start_insert=1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
"
" memolist settings
let g:memolist_unite = 1
let g:memolist_memo_suffix = 'md'
let g:memolist_template_dir_path = "~/memo/.template"
nmap <leader>mn :MemoNew<CR>
nmap <leader>ml :MemoList<CR>
nmap <leader>mg :MemoGrep<CR>

" indentLine settings
let g:indentLine_color_term = 111
let g:indentLine_char = '¦'

syntax on
