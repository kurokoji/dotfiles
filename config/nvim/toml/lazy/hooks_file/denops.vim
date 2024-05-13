" hook_add {{{
if has('win32') || has('win64')
  let g:denops_server_addr = '127.0.0.1:32123'
endif

" If you use dein.vim, you can get the path via `dein#get('denops.vim').path`.
" Or if you are a user of jetpack.vim, you can use `jetpack#get('denops.vim').path`.
" let s:denops_path = dein#get('denops.vim').path
" let s:cli_path = expand(s:denops_path . '/denops/@denops-private/cli.ts')
"
" if has('nvim')
"     call jobstart(
"     \	'deno run -A --no-lock ' . s:cli_path,
"     \	{'detach': v:true}
"     \)
" else
"     call job_start(
"     \   'deno run -A --no-check ' . s:cli_path,
"     \   {'stoponexit': ''}
"     \)
" endif
" }}}
