" mapping {{{
tnoremap <ESC> <C-\><C-n>
nnoremap ; :
nnoremap x "_x

nnoremap ss <Cmd>sp<CR>
nnoremap sv <Cmd>vs<CR>

nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" nnoremap sn gt
" nnoremap sp gT
nnoremap <Tab> gt
nnoremap st <Cmd>tabnew<CR>

nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
let mapleader = "\<Space>"

cnoremap <C-a> <Home>
cnoremap <C-h> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-l> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-y> <C-r>*
cnoremap <C-g> <C-c>
" }}}

" dein {{{
let g:dein#enable_notification = 1
let g:dein#install_progress_type = 'floating'

let s:dein_dir = expand('~/.config/nvim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = s:dein_dir . '/../toml'

if !isdirectory(s:dein_repo_dir)
  echo 'install dein'
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

let s:toml_file = s:toml_dir . '/dein.toml'
let s:lazy_file = s:toml_dir . '/dein_lazy.toml'
let s:ddu_file = s:toml_dir . '/dein_ddu.toml'
let s:theme_file = s:toml_dir . '/theme.toml'
let s:syntax_file = s:toml_dir . '/syntax.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:theme_file, {'lazy': 0})
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:syntax_file, {'lazy': 0})
  call dein#load_toml(s:lazy_file, {'lazy': 1})
  call dein#load_toml(s:ddu_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" call dein#remote_plugins()

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" }}}

set backspace=indent,eol,start

set writebackup
set infercase
set autoread
set nowrap
set foldmethod=marker

set fileformats=unix,dos,mac
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp

if has('nvim')
  set wildoptions=pum
  set pumblend=30
endif

if has('win32') || has ('win64')
  set shell=pwsh
endif


syntax enable
set title
set number
set cursorline
set list
" set ambiwidth=double
set listchars=tab:>-,eol:¬,nbsp:%,nbsp:⍽
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set laststatus=2
set showtabline=2
" set completeopt=preview
set completeopt=menuone,noinsert,noselect
set wildmenu
set wildmode=full


set noshowmode
set incsearch
set background=light
set termguicolors
autocmd ColorScheme * hi dOperator guifg=#fb4934
colorscheme iceberg

" 透過関連
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermbg=NONE guibg=NONE
hi! Folded ctermbg=NONE guibg=NONE
hi! EndOfBuffer ctermbg=NONE guibg=NONE
hi! CursorLine ctermbg=NONE guibg=NONE
hi! SpecialKey ctermbg=NONE guibg=NONE

" 新しいウィンドウを下に開く
set splitbelow

set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set smartindent
set ttyfast

set guifont=PlemolJP\ Console\ NF:h16

let g:tex_conceal = ""

filetype on
filetype plugin indent on
autocmd FileType python set tabstop=4 shiftwidth=4
autocmd FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType java set softtabstop=4 tabstop=4 shiftwidth=4
autocmd FileType c,cpp set softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
autocmd FileType json set tabstop=2 shiftwidth=2 noexpandtab
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType go set tabstop=4 shiftwidth=4 noexpandtab
autocmd FileType d set softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
autocmd Filetype html setlocal indentexpr=""
autocmd FileType javascript set expandtab
