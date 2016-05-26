
set go-=T
set viminfo=
set noswapfile

if has('win32')
  let $MYVIMRC='$HOME/.vimrc'
  colorscheme desert
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

if exists('&imdisableactivate')
  set noimdisableactivate
endif

colorscheme solarized
