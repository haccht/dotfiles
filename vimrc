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
set ttyfast
set scrolloff=2
set updatetime=1000

" indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2 autoindent
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 autoindent
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4 autoindent
  autocmd BufNewFile,BufRead *.md setlocal tabstop=4 softtabstop=4 shiftwidth=4
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
if isdirectory($HOME . "/.vim/backup")
  set backup
  set backupdir=$HOME/.vim/backup
endif
if isdirectory($HOME . "/.vim/undo")
  set undofile
  set undodir=$HOME/.vim/undo
endif

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
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
cnoremap <C-p> <Up>

" plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tomasr/molokai'
Plug 'itchyny/lightline.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'mattn/vim-goimports'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-markdown'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'cocopon/vaffle.vim'
call plug#end()

let g:vaffle_show_hidden_files = 1
nnoremap <silent> - :execute 'Vaffle ' . ((strlen(bufname('')) == 0) ? '.' : '%:h')<CR>

let g:quickrun_config = {
      \  '_': {
        \    'outputter/buffer/split': ':botright 10',
        \    'outputter/buffer/close_on_empty': 1
        \  },
        \   'bundle': {
          \    'cmdopt': 'bundle exec',
          \    'command': 'ruby',
          \    'exec': '%o %c %s'
          \  }}
nnoremap <Leader>q :<C-u>bw! \[quickrun\ output\]<CR>

map <Leader>g :GitGutterToggle<CR>

" lsp
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd   <plug>(lsp-definition)
  nmap <buffer> gD   <plug>(lsp-references)
  nmap <buffer> gs   <plug>(lsp-document-symbol)
  nmap <buffer> gS   <plug>(lsp-workspace-symbol)
  nmap <buffer> gQ   <plug>(lsp-document-format)
  nmap <buffer> K    <plug>(lsp-hover)
  nmap <buffer> <F1> <plug>(lsp-implementation)
  nmap <buffer> <F2> <plug>(lsp-rename)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_signs_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
" let g:asyncomplete_auto_popup = 1
" let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_preview_float = 1
let g:lsp_diagnostics_float_cursor = 1
let g:goimports = 1
