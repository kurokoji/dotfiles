" hook_add {{{
let g:deol#enable_ddc_completion = v:true
" let g:deol#floating_border = ['╭', '─', '╮', '│', '╯', '─', '╰', '│']
let g:deol#floating_border = ['┏', '━', '┓', '┃', '┛', '━', '┗', '┃']

function s:floating_deol() abort
  let width_per = 0.8
  let height_per = 0.6

  let winwidth = float2nr(&columns * width_per)
  let wincol = float2nr((&columns - (&columns * width_per)) / 2)
  let winheight = float2nr(&lines * height_per)
  let winrow = float2nr((&lines - (&lines * height_per)) / 2)

  call deol#start(#{split: 'floating', winwidth: winwidth, winheight: winheight, wincol: wincol, winrow: winrow, toggle: v:true})
endfunction

function! s:open_deol() abort
  let winheight = &lines / 2

  call deol#start(#{split: 'horizontal', winheight: winheight, toggle: v:true})
endfunction

command DeolSplit :call deol#start(#{split: 'horizontal', toggle: v:true})
command DeolVertical :call deol#start(#{split: 'vertical', toggle: v:true})
command DeolFloating :call s:floating_deol()

nnoremap <Leader>s <Cmd>DeolSplit<CR>
nnoremap <Leader>v <Cmd>DeolVertical<CR>
nnoremap <Leader>t <Cmd>DeolFloating<CR>
" }}}
