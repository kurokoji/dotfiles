" hook_add {{{
function! s:skkeleton_init() abort
  call skkeleton#config({
        \ 'eggLikeNewline': v:true,
        \ 'globalJisyo': '~/.skk/SKK-JISYO.L',
        \ })
endfunction

function! s:skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! s:skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction


autocmd User skkeleton-initialize-pre call s:skkeleton_init()
autocmd User skkeleton-enable-pre call s:skkeleton_pre()
autocmd User skkeleton-disable-pre call s:skkeleton_post()

imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
" }}}
