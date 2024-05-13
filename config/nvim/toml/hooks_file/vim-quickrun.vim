" hook_add {{{
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_no_default_key_mappings=1

let g:quickrun_config._ = {
      \ 'runner': 'nvimterm',
      \ 'runner/nvimterm/into': 1,
      \ 'runner/nvimterm/opener': 'auto',
      \ 'runner/nvimterm/vsplit_width': 150,
      \ }

let g:quickrun_config.d = {
      \ 'command': 'dmd',
      \ 'cmdopt': '-debug -run'
      \ }

let g:quickrun_config.cpp = {
      \ 'command': 'g++',
      \ 'cmdopt': '-std=c++2a -O3'
      \ }

let g:quickrun_config.scheme = {
      \ 'command': 'scheme',
      \ 'exec': '%c %o < %s',
      \ 'cmdopt': '--quiet'
      \ }

nnoremap <silent> <C-b> <Cmd>QuickRun<CR> i
" }}}
