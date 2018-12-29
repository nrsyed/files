"	VIM configuration file

syntax on

set runtimepath^=~/.vim/ftplugin/html/html.vim
set runtimepath^=~/.vim/ftplugin/py/python.vim

set number
setl et ts=2 sw=2 sts=2

au Filetype cpp setl et ts=4 sw=4 sts=4 autoindent

au Filetype python setl et ts=4 sw=4 sts=4
	\ cinwords=if,elif,else,for,while,try,except,
	\finally,def,class

au Filetype css setl et ts=2 sw=2 sts=2 smartindent
au Filetype html setl et ts=2 sw=2 sts=2 smartindent
au Filetype md setl et ts=2 sw=2 sts=2 smartindent

"filetype indent on
filetype plugin indent on
