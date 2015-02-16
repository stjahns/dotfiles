set nocompatible
set guioptions-=r
set guioptions-=L
set noswapfile
filetype off

"set hidden " Switch buffers without needing to save
set confirm " Confirmation dialog when leaving unsaved buffer

" Setup packages

if has("gui_running")
  if has("gui_win32")
    set rtp+=~/vimfiles/bundle/Vundle.vim
  else
    set rtp+=~/.vim/bundle/Vundle.vim
  endif
else
  set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()	     " required

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-leiningen'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'vim-scripts/candycode.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'guns/vim-sexp'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdcommenter'
Plugin 'avakhov/vim-yaml'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'cespare/vim-toml'
Plugin 'wting/rust.vim'
Plugin 'phildawes/racer'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-rooter'
Plugin 'bronson/vim-trailing-whitespace'

call vundle#end()            " required
filetype plugin indent on    " required

" Platform-specific setup

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h11
    set macmeta
  elseif has("gui_win32")
    set guifont=Consolas:h12:cANSI
    set guioptions-=m
    set guioptions-=T
  endif
endif

" Color scheme

colorscheme desert
syntax enable

" Set leader to space

let mapleader = " "
let maplocalleader = " "

" Rainbow parens

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Unite bindings

call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>pf :Unite file_rec -start-insert <cr>
nnoremap <leader>ff :Unite file -start-insert <cr>
nnoremap <leader>fr :Unite file_mru -start-insert <cr>
nnoremap <leader>bb :Unite buffer -start-insert <cr>

nnoremap <leader>// :Unite grep:. <cr>
nnoremap <leader>/p :UniteWithCursorWord grep:. <cr>

" Use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" Fugitive bindings
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" Fireplace bindings
vnoremap <leader>er :Eval <cr>
nnoremap <leader>ef :%Eval <cr>

" Ripple-related bindings
nnoremap <leader>rr :Eval (ripple.repl/rra)<cr>

" Toggle line numbers
nnoremap <leader>tn :set invnumber<CR>

" Make backspace work 'normally'
set backspace=2

" Case-insensitive search
set ignorecase

":[range]Execute    Execute text lines as ex commands.
"           Handles |line-continuation|.
command! -bar -range Execute silent <line1>,<line2>yank z | let @z = substitute(@z, '\n\s*\\', '', 'g') | @z

set iskeyword-=-

" Emacs-style window closing
nnoremap 0 c
nnoremap 1 o

nnoremap <leader>1 1
nnoremap <leader>2 2

nnoremap <M-{> :tabp<cr>
nnoremap <M-}> :tabn<cr>
nnoremap <M-t> :tabnew<cr>
nnoremap <M-w> :tabclose<cr>

" EasyMotion
nmap s <Plug>(easymotion-s)

" Rust
let g:racer_cmd = "/Users/jahns/.vim/bundle/racer/target/release/racer"
let $RUST_SRC_PATH="~/rust/src/"

nnoremap <leader>cr :!cargo run<CR>
nnoremap <leader>ct :!cargo test<CR>
nnoremap <leader>cm :!cargo build<CR>
