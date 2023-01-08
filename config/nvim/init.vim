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
" let g:dein#install_progress_type = 'floating'
let g:dein#install_process_timeout = 360
let g:dein#install_max_processes = 8

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE . '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

let s:toml_dir = expand('~/.config/nvim/toml')

let s:toml_file = s:toml_dir . '/dein.toml'
let s:lazy_file = s:toml_dir . '/lazy.toml'
let s:ddu_file = s:toml_dir . '/ddu.toml'
let s:ddc_file = s:toml_dir . '/ddc.toml'
let s:theme_file = s:toml_dir . '/theme.toml'
let s:syntax_file = s:toml_dir . '/syntax.toml'

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:theme_file, {'lazy': 0})
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:syntax_file, {'lazy': 0})
  call dein#load_toml(s:lazy_file, {'lazy': 1})
  call dein#load_toml(s:ddu_file, {'lazy': 1})
  call dein#load_toml(s:ddc_file, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" call dein#remote_plugins()

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" }}}

set backspace=indent,eol,start

" disable mouse
set mouse=

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
  " set pumblend=20
  " set winblend=20
endif

if has('win32') || has ('win64')
  set shell=pwsh
endif


syntax enable
set title
set number
set cursorline
set signcolumn=yes
set list
" set ambiwidth=double
set listchars=tab:>-,eol:¬,nbsp:%,nbsp:⍽
"set listchars=tab:>-,eol:↵,nbsp:%,nbsp:⍽
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set laststatus=2
set showtabline=2
" set completeopt=preview
set completeopt=menuone,noselect
set wildmenu
set wildmode=full


set noshowmode
set incsearch
set background=light
set termguicolors
autocmd ColorScheme * hi dOperator guifg=#fb4934
colorscheme dayfox

let s:use_neovide = exists('g:neovide')
let s:use_gui = s:use_neovide || has('gui_running')

if s:use_neovide
  let g:neovide_floating_blur_amount_x = 2.0
  let g:neovide_floating_blur_amount_y = 2.0
endif

function! s:enable_transparent() abort
  if !s:use_gui
    " 透過関連
    hi! Normal ctermbg=NONE guibg=NONE
    hi! NormalNC ctermbg=NONE guibg=NONE
    hi! NormalFloat ctermbg=NONE guibg=NONE
    hi! WinBar ctermbg=NONE guibg=NONE
    hi! WinBarNC ctermbg=NONE guibg=NONE
    hi! Special ctermbg=NONE guibg=NONE
    "hi! NonText ctermbg=NONE guibg=NONE
    "hi! LineNr ctermbg=NONE guibg=NONE
    "hi! SignColumn ctermbg=NONE guibg=NONE
    " hi! VertSplit ctermbg=NONE guibg=NONE
    "hi! Folded ctermbg=NONE guibg=NONE
    "hi! EndOfBuffer ctermbg=NONE guibg=NONE
    "hi! CursorLine ctermbg=NONE guibg=NONE
    "hi! SpecialKey ctermbg=NONE guibg=NONE
  elseif s:use_neovide
    let g:neovide_transparency=0.95
  endif
endfunction
call s:enable_transparent()

" FloatingWindowの透過
" hi! NormalFloat ctermbg=NONE guibg=NONE gui=NONE

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

if has('win32') || has ('win64')
  set guifont=PlemolJP\ Console\ NF:h12
else
  set guifont=PlemolJP\ Console\ NF:h15
endif

let g:tex_conceal = ''

filetype on
filetype plugin indent on

augroup FileTypeConfig
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4
  autocmd FileType java setlocal softtabstop=4 tabstop=4 shiftwidth=4
  autocmd FileType c,cpp setlocal softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType d setlocal softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
  autocmd Filetype html setlocal indentexpr=""

  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

augroup MyFileType
  autocmd!
  autocmd BufNewFile,BufRead *.bigquery set filetype=sql
augroup END
