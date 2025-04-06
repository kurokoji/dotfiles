" mapping {{{
tnoremap <ESC> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>
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
nnoremap <S-Tab> gT
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

" dpp.vim {{{

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

const s:dpp_base_dir = expand('$CACHE/dpp')
const s:dpp_dir = expand(s:dpp_base_dir .. '/repos/github.com/Shougo/dpp.vim')
const s:denops_dir = expand(s:dpp_base_dir .. '/repos/github.com/vim-denops/denops.vim')

const s:dpp_exts = ['Shougo/dpp-ext-installer', 'Shougo/dpp-ext-lazy', 'Shougo/dpp-ext-toml', 'Shougo/dpp-protocol-git']

if &runtimepath !~# '/dpp.vim'
  if !isdirectory(s:dpp_dir)
    echo 'install dpp.vim'
    execute '!git clone https://github.com/Shougo/dpp.vim' s:dpp_dir
  endif

  execute 'set runtimepath^=' . substitute(fnamemodify(s:dpp_dir, ':p'), '[/\\]$', '', '')
endif

for ext in s:dpp_exts
  if !isdirectory(expand(s:dpp_base_dir .. '/repos/github.com/' .. ext))
    echo 'install ' .. ext
    execute '!git clone https://github.com/' .. ext expand(s:dpp_base_dir .. '/repos/github.com/' .. ext)
  endif
endfor

let $BASE_DIR = fnamemodify(expand('<sfile>'), ':h')
let $NORMAL_TOML_DIR = expand('$BASE_DIR/toml/normal')
let $LAZY_TOML_DIR = expand('$BASE_DIR/toml/lazy')
let $DPP_CONFIG = expand('$BASE_DIR/dpp.ts')

if dpp#min#load_state(s:dpp_base_dir)
  if &runtimepath !~# '/denops.vim'
    if !isdirectory(s:denops_dir)
      echo 'install denops.vim'
      execute '!git clone https://github.com/vim-denops/denops.vim' s:denops_dir
    endif

    execute 'set runtimepath^=' . substitute(fnamemodify(s:denops_dir, ':p'), '[/\\]$', '', '')
  endif

  for ext in s:dpp_exts
    execute 'set runtimepath^=' . expand(s:dpp_base_dir .. '/repos/github.com/' .. ext)
  endfor

  autocmd User DenopsReady
    \ : echohl WarningMsg
    \ | echomsg 'dpp load_state() is failed'
    \ | echohl NONE
    \ | call dpp#make_state(s:dpp_base_dir, $DPP_CONFIG)
else
  autocmd BufWritePost *.lua,*.vim,*.toml,*.ts,init.vim
    \ call dpp#check_files()

  autocmd BufWritePost *.toml
    \ : if !dpp#sync_ext_action('installer', 'getNotInstalled')->empty()
    \ |  call dpp#async_ext_action('installer', 'install')
    \ | endif
endif

autocmd User Dpp:makeStatePost
  \ : echohl WarningMs
  \ | echomsg 'dpp make_state() is done'
  \ | echohl NONE


command DppInstall call dpp#async_ext_action('installer', 'install')
command DppUpdate call dpp#async_ext_action('installer', 'update')

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

set exrc
set secure
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
set listchars=tab:⇥⇥,eol:↵,nbsp:⍽,trail:·,extends:»,precedes:«

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
" let g:material_style = 'lighter'
" colorscheme material
" colorscheme tokyonight-day
colorscheme melange
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
  autocmd BufNewFile,BufRead *.rbi,*.schema,Schemafile set filetype=ruby
augroup END

" autocmd VimLeavePre * ++nested set guicursor=n-v-c:block-Cursor
" set guicursor=n-v-c:block-Cursor
set guicursor=n-v-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor

function! CloseAllFloatingWindows()
  " 現在表示されているすべてのウィンドウのリストを取得
  let windows = nvim_list_wins()

  " 各ウィンドウをチェックし、フローティングウィンドウであれば閉じる
  for win in windows
    let config = nvim_win_get_config(win)
    if !empty(config.relative)
      call nvim_win_close(win, v:true)
    endif
  endfor
endfunction

command! CloseAllFloatingWindows call CloseAllFloatingWindows()
