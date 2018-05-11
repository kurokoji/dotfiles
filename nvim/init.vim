if &compatible
  set nocompatible
endif

" dein {{{

let s:dein_dir = expand('~/.config/nvim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = s:dein_dir . '/../toml'

if !isdirectory(s:dein_repo_dir)
  echo 'install dein'
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

set runtimepath^=s:dein_repo_dir

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

let s:toml_file = s:toml_dir . '/dein.toml'
let s:lazy_file = s:toml_dir . '/dein_lazy.toml'
let s:theme_file = s:toml_dir . '/theme.toml'
let s:syntax_file = s:toml_dir . '/syntax.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:theme_file, {'lazy': 0})
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:syntax_file, {'lazy': 0})
  call dein#load_toml(s:lazy_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" }}}

set backspace=indent,eol,start

" inoremap <C-j> <esc>
" noremap <C-j> <esc>
tnoremap <C-[> <C-\><C-n>

set writebackup
set infercase
set autoread
set nowrap

set foldmethod=marker

set fileformat=unix
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fencs=utf-8,iso-2022-jp,enc-jp,cp932

syntax enable
set title
set number
set cursorline
" set cursorcolumn
set list
" set listchars=tab:»-,eol:⇣,extends:»,precedes:«,nbsp:%
set listchars=tab:>-,eol:↓,nbsp:%
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set laststatus=2
set showtabline=2
set completeopt=menuone,noinsert,noselect
set wildmenu
set noshowmode
" set ambiwidth=double
set incsearch
"set relativenumber
" set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark
let g:deus_termcolors=256
set t_Co=256
colorscheme deus
" colorscheme monokai_pro
"let g:molokai_original = 1

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set smartindent
set ttyfast

filetype on
filetype plugin indent on
autocmd FileType python set tabstop=4 shiftwidth=4
autocmd FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType c,cpp set cindent cinoptions+=:0,g0
autocmd FileType go set tabstop=4 shiftwidth=4 noexpandtab
autocmd FileType d set softtabstop=4 shiftwidth=4 cindent cinoptions+=:0,g0
autocmd Filetype html setlocal indentexpr=""
