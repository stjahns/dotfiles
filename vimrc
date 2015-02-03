set nocompatible
set guioptions-=r
set guioptions-=L
set noswapfile
filetype off

" Setup packages

set rtp+=~/vimfiles/bundle/Vundle.vim
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
Plugin 'stephpy/vim-yaml'
Plugin 'flazz/vim-colorschemes'

call vundle#end()            " required
filetype plugin indent on    " required

" Platform-specific setup

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
    set macmeta
  elseif has("gui_win32")
    set guifont=Consolas:h12:cANSI
    set guioptions-=m
    set guioptions-=T
  endif
endif

" Color scheme

colorscheme sonofobsidian
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
nnoremap <leader>pf :Unite file_rec/async -start-insert <cr>
nnoremap <leader>ff :Unite file -start-insert <cr>
nnoremap <leader>fr :Unite file_mru -start-insert <cr>
nnoremap <leader>bb :Unite buffer -start-insert <cr>
nnoremap <leader>/ :Unite grep:. <cr>

" Use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" Fugitive bindings
nnoremap <leader>gs :Gstatus<cr>

" Fireplace bindings
vnoremap <leader>er :Eval <cr>
nnoremap <leader>ef :%Eval <cr>

" Ripple-related bindings
nnoremap <leader>rr :Eval (ripple.repl/rra)<cr>

" Toggle line numbers
nnoremap <leader>tn :set invnumber<CR>
