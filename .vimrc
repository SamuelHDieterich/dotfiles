" Plugins
call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'chrisbra/Colorizer'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

call plug#end()


" Colorscheme
colorscheme onedark
let g:onedark_terminal_italics=1
let g:airline_theme='onedark'
hi Normal guibg=NONE ctermbg=NONE


" General settings
set nu!
set mouse=a
set title
"set cursorline
set encoding=utf-8

set termguicolors

set tabstop=4
set shiftwidth=4

filetype plugin on


" Maps
map q :quit<CR>
map <C-s> :write<CR>

" YouCompleteMe
set completeopt-=preview

" Powerline
set laststatus=2

