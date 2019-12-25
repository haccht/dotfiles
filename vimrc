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
"set backup
"set backupdir=$HOME/.vim/backup
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
let g:quickrun_config={'_': {'split': ''}}
set splitbelow
set splitright

let g:gitgutter_enabled = 0
map <Leader>g :GitGutterToggle<CR>

" settings for go
let g:go_version_warning = 0
if executable('gopls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
endif

" settings for ruby
if executable('solargraph')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif
