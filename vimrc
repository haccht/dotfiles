" ---------------------------------------------------------------------------
" Initialization & Encodings
" ---------------------------------------------------------------------------
filetype plugin indent on
syntax on

let s:data_dir = has('nvim') ? stdpath('data') . '/site' : expand('~/.vim')

if has('vim_starting')
  set encoding=utf-8
  set fileencodings=utf-8,ucs-bom,euc-jp,cp932,sjis
  set fileformats=unix,dos,mac
endif
scriptencoding utf-8

" ---------------------------------------------------------------------------
" Core Options
" ---------------------------------------------------------------------------
set t_vb=
set novisualbell
set noerrorbells
set ambiwidth=double
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
set laststatus=2
set scrolloff=2
set updatetime=1000

" Indentation
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Clipboard, Completion & Splits
set clipboard^=unnamed,unnamedplus
set completeopt=menuone,noinsert,noselect
set splitright
set splitbelow

" Persistent Undo & Backup
for s:dir in ['undo', 'backup']
  if !isdirectory(s:data_dir . '/' . s:dir)
    silent! call mkdir(s:data_dir . '/' . s:dir, 'p')
  endif
endfor
if isdirectory(s:data_dir . '/undo')
  set undofile
  let &undodir = s:data_dir . '/undo'
endif
if isdirectory(s:data_dir . '/backup')
  set backup
  let &backupdir = s:data_dir . '/backup'
endif

" ---------------------------------------------------------------------------
" Key Mappings & Filetype Rules
" ---------------------------------------------------------------------------
let mapleader = ','
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR><Esc>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

augroup FileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ---------------------------------------------------------------------------
" Plugins (vim-plug)
" ---------------------------------------------------------------------------
if empty(glob(s:data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . s:data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-goimports'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-markdown'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'NLKNguyen/papercolor-theme'
Plug 'andymass/vim-matchup'
call plug#end()

" ---------------------------------------------------------------------------
" Appearance & Colorscheme
" ---------------------------------------------------------------------------
set t_Co=256
set cursorline
set background=dark

augroup TransparentBg
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none
  autocmd ColorScheme * highlight LineNr ctermbg=none
augroup END

if filereadable(expand(s:data_dir . '/plugged/papercolor-theme/colors/PaperColor.vim'))
  colorscheme PaperColor
  let g:lightline = { 'colorscheme': 'PaperColor' }
else
  colorscheme murphy
endif

" ---------------------------------------------------------------------------
" Netrw
" ---------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_timefmt = '%Y/%m/%d(%a) %H:%M:%S'
let g:netrw_hide = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

augroup NetrwKeyMap
  autocmd!
  autocmd FileType netrw nmap <buffer> . gh
augroup END

" ---------------------------------------------------------------------------
" LSP & Plugin Configuration
" ---------------------------------------------------------------------------
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

augroup LspInstall
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

nnoremap <Leader>g :<C-u>GitGutterToggle<CR>
nnoremap <Leader>q :<C-u>bw! \[quickrun\ output\]<CR>

let g:goimports = 1
let g:lsp_signs_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_text_edit_enabled = 1
let g:lsp_preview_float = 1
let g:lsp_diagnostics_float_cursor = 1
let g:asyncomplete_popup_delay = 200

let g:vim_json_conceal = 0
let g:indentLine_concealcursor = 'nc'
