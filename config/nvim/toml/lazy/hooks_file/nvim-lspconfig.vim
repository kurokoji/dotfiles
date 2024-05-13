" hook_add {{{
nmap <silent> <Leader>rn <Cmd>lua vim.lsp.buf.rename()<CR>
nmap <silent> <Leader>h <Cmd>lua vim.lsp.buf.hover()<CR>
" nmap <silent> <Leader>ca <Cmd>lua vim.lsp.buf.code_action()<CR>
nmap <silent> <Leader>f <Cmd>lua vim.diagnostic.open_float()<CR>
" nmap <silent> gd <Cmd>lua vim.lsp.buf.definition()<CR>
" nmap <silent> gt <Cmd>lua vim.lsp.buf.type_definition()<CR>
" nmap <silent> gi <Cmd>lua vim.lsp.buf.implementation()<CR>
" nmap <silent> gr <Cmd>lua vim.lsp.buf.references()<CR>
nmap <silent> g] <Cmd>lua vim.diagnostic.goto_next()<CR>
nmap <silent> g[ <Cmd>lua vim.diagnostic.goto_prev()<CR>
nmap <silent> F <Cmd>lua vim.lsp.buf.format { async = true }<CR>
" }}}
