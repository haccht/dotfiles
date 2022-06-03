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
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

" encrypt
if has('crypt-blowfish2')
  set cryptmethod=blowfish2
endif

" global
set t_vb=
set novisualbell
set noerrorbells
set clipboard=unnamed
if isdirectory($HOME . "/.vim/undo")
  set undofile
  set undodir=$HOME/.vim/undo
endif
if isdirectory($HOME . "/.vim/backup")
  set backup
  set backupdir=$HOME/.vim/backup
endif
set pastetoggle=<F10>


" colors
syntax on
set t_Co=256
set cursorline
set background=dark
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
colorscheme murphy

" mapping
let mapleader=','
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
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
Plug 'Yggdroot/indentLine'
Plug 'NLKNguyen/papercolor-theme'
call plug#end()

" colorscheme
if filereadable(expand("~/.vim/plugged/papercolor-theme/colors/PaperColor.vim"))
  colorscheme PaperColor
  let g:lightline = { 'colorscheme': 'PaperColor' }
endif

" netrw
let g:netrw_banner=0
"let g:netrw_liststyle=1
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_hide=1
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
augroup NetrwKeyMap
    au!
    au FileType netrw nmap <buffer> . gh
augroup END

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

" plugin-settings
let g:goimports = 1
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

map <Leader>g :GitGutterToggle<CR>
