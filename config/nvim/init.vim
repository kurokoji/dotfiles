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

" クリップボードにコピー
" Linuxの場合、xselをインストールすれば使えるようになるはず
vnoremap <C-y> "+y
" }}}

" dein {{{
let g:dein#enable_notification = 1
" let g:dein#install_progress_type = 'floating'
let g:dein#install_process_timeout = 360
let g:dein#install_max_processes = 8
" let g:dein#hooks_file_marker = '[[[,]]]'

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

" if &runtimepath !~# '/dein.vim'
"   let s:dein_dir = fnamemodify('dein.vim', ':p')
"   if !isdirectory(s:dein_dir)
"     let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
"     if !isdirectory(s:dein_dir)
"       echo "install dein.vim"
"       execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
"     endif
"   endif
"   execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
" endif

let s:dein_base_dir = expand('$CACHE/dein')
let s:dein_dir = expand(s:dein_base_dir .. '/repos/github.com/Shougo/dein.vim')

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_dir)
    echo 'install dein.vim'
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif

  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p'), '[/\\]$', '', '')
endif

let $BASE_DIR = fnamemodify(expand('<sfile>'), ':h')
let $NORMAL_TOML_DIR = expand('$BASE_DIR/toml/normal')
let $LAZY_TOML_DIR = expand('$BASE_DIR/toml/lazy')

let s:normal_toml_list = split(glob($NORMAL_TOML_DIR .. '/*.toml'), '\n')
let s:lazy_toml_list = split(glob($LAZY_TOML_DIR .. '/*.toml'), '\n')

if dein#min#load_state(s:dein_base_dir)
  call dein#begin(s:dein_base_dir)

  for toml in s:normal_toml_list
    call dein#load_toml(toml, #{ lazy: 0 })
  endfor

  for toml in s:lazy_toml_list
    " if (toml =~ "ddc.toml") || (toml =~ "ddu.toml")
    "   continue
    " endif
    if (toml =~ "completion.toml")
      continue
    endif
    call dein#load_toml(toml, #{ lazy: 1 })
  endfor

  call dein#end()
  " デフォルトではnon lazyなプラグインではhook_source(lua_source)は呼び出されないので強制的にhook_sourceを呼び出している
  " https://github.com/Shougo/dein.vim/blob/13e1fe4afcac7816d9b4d925eba656d15693fdba/doc/dein.txt#L1804
  call dein#call_hook('source')

  call dein#save_state()
endif

" call dein#remote_plugins()

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" }}}

set backspace=indent,eol,start

" Search
" 小文字の場合は大文字も検索対象となるが、大文字の場合は大文字のみにマッチする
set ignorecase
set smartcase
set wrapscan
set incsearch

" モードを表示しない(lualineがあるので)
set noshowmode

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
  " :help shell-powershell
  let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
  let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif

if has('syntax')
  syntax on
endif

set title
set number
set cursorline
set signcolumn=yes
set list
" set ambiwidth=double
" set listchars=tab:>-,eol:¬,nbsp:%,nbsp:⍽
set listchars=tab:>-,eol:↵,nbsp:⍽,trail:·,extends:»,precedes:«

" 対応するカッコの表示
set showmatch
set matchtime=1

set matchpairs& matchpairs+=<:>
set laststatus=2
set showtabline=2
" set completeopt=preview
set completeopt=menuone,noselect
set wildmenu
set wildmode=full

set background=light
set termguicolors
autocmd ColorScheme * hi dOperator guifg=#fb4934
let g:material_style = 'lighter'
colorscheme material
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
" call s:enable_transparent()

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
  set guifont=UDEV\ Gothic\ NF:h12
else
  set guifont=UDEV\ Gothic\ NF:h15
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
  autocmd FileType lua setlocal tabstop=2 shiftwidth=2 noexpandtab
  autocmd FileType d setlocal softtabstop=2 tabstop=2 shiftwidth=2 cindent cinoptions+=:0,g0
  autocmd Filetype html setlocal indentexpr=""

  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

augroup MyFileType
  autocmd!
  autocmd BufNewFile,BufRead *.bigquery set filetype=sql
augroup END
