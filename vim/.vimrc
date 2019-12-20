"	VIM configuration file

syntax on

set background=dark
set hlsearch

set number
setl et ts=2 sw=2 sts=2 ai
set foldmethod=indent

au Filetype cpp setl et ts=4 sw=4 sts=4 autoindent
au Filetype css setl et ts=2 sw=2 sts=2 smartindent
au Filetype md setl et ts=2 sw=2 sts=2 smartindent

filetype plugin indent on

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
