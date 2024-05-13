" hook_source {{{

" call pum#set_option('max_width', 80)
call pum#set_option('padding', v:false)
call pum#set_option('border', ['╭', '─', '╮', '│', '╯', '─', '╰', '│'])
" call pum#set_option('border', ['┏', '━', '┓', '┃', '┛', '━', '┗', '┃'])
call pum#set_option('highlight_normal_menu', '')
" call pum#set_option('scrollbar_char', '')
call pum#set_option('max_height', '20')
" call pum#set_option('scrollbar_char', '┃')
" call pum#set_option('scrollbar_char', '█')
call pum#set_option('scrollbar_char', '▌')
call pum#set_option('highlight_scrollbar', '')

" コマンドラインモードでの補完候補の表示位置を調整(ボーダーラインを表示しているためずれる)
call pum#set_option('offset_cmdrow', 2)

inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
" inoremap <silent><expr> <Tab>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"       \ '<Tab>'
" inoremap <silent><expr> <S-Tab>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' :
"       \ '<S-Tab>'

tnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
tnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>

" }}}
