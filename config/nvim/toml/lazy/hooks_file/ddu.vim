" hook_add {{{
"nnoremap <silent> <C-u><C-p> :call ddu#start()<CR>
nnoremap <silent> <C-u><C-p> <Cmd>call ddu#start(#{ name: 'fd-file_rec' })<CR>
"nnoremap <silent> <C-u><C-p> :call ddu#start(#{ name: 'file_rec' })<CR>
nnoremap <silent> <C-u><C-g> <Cmd>call ddu#start(#{ name: 'grep' })<CR>
nnoremap <silent> <C-u><C-]>
      \ <Cmd>call ddu#start(#{
      \   name: 'grep',
      \   sources: [#{
      \     name: 'rg',
      \     params: #{
      \       input: expand('<cword>')
      \     }
      \   }]
      \ })<CR>
" nnoremap <silent> <C-u><C-]> :call ddu#start(#{ name: 'cursor-grep' })<CR>
nnoremap <silent> <C-u><C-m> <Cmd>call ddu#start(#{ name: 'filer' })<CR>

nnoremap <silent> gd <Cmd>call ddu#start(#{ name: 'lsp:definition' })<CR>
nnoremap <silent> gt <Cmd>call ddu#start(#{ name: 'lsp:type_definition' })<CR>
nnoremap <silent> gi <Cmd>call ddu#start(#{ name: 'lsp:implementation' })<CR>
nnoremap <silent> gr <Cmd>call ddu#start(#{ name: 'lsp:references' })<CR>
nnoremap <silent> <Leader>ca <Cmd>call ddu#start(#{ name: 'lsp:code_action' })<CR>
nnoremap <silent> <Leader>ds <Cmd>call ddu#start(#{ name: 'lsp:document_symbol' })<CR>
nnoremap <silent> <Leader>ws <Cmd>call ddu#start(#{ name: 'lsp:workspace_symbol' })<CR>
nnoremap <silent> <Leader>di <Cmd>call ddu#start(#{ name: 'lsp:diagnostic' })<CR>

" }}}

" hook_source {{{
let g:ddu_source_lsp_clientName = 'nvim-lsp'

call ddu#custom#patch_global(#{
    \   ui: 'ff',
    \   sourceOptions: #{
    \     _: #{
    \       matchers: ['matcher_substring'],
    \     },
    \     file_rec: #{
    \       matchers: ['matcher_fzf'],
    \       sorters: ['sorter_fzf'],
    \       columns: ['icon_filename']
    \     },
    \     file_external: #{
    \       matchers: ['matcher_fzf'],
    \       sorters: ['sorter_fzf'],
    \       columns: ['icon_filename']
    \     },
    \     file: #{
    \       matchers: ['matcher_substring'],
    \       columns: ['icon_filename'],
    \     },
    \   },
    \   sourceParams: #{
    \     file_rec: #{
    \       ignoredDirectories: ['.git', 'node_modules', '.cache', 'go']
    \     },
    \   },
    \   columnParams: #{
    \     icon_filename: #{
    \       padding: 0,
    \       span: 2,
    \       pathDisplayOption: "relative",
    \       defaultIcon: #{ icon: '' },
    \       colors: #{
    \         default: 'Normal',
    \         aqua: '#74b2c9',
    \         beige: '#a36f3e',
    \         blue: '#4e75aa',
    \         brown: '#ba793e',
    \         darkBlue: '#485e7d',
    \         darkOrange: '#d76558',
    \         green: '#629f81',
    \         lightGreen: '#618774',
    \         lightPurple: '#8e6f98',
    \         orange: '#e8857a',
    \         pink: '#de8db7',
    \         purple: '#9f75ac',
    \         red: '#c76882',
    \         salmon: '#b95d76',
    \         yellow: '#ca884a',
    \       }
    \     }
    \   },
    \   kindOptions: #{
    \     file: #{
    \       defaultAction: 'open',
    \     },
    \     lsp: #{
    \       defaultAction: 'open',
    \     },
    \     lsp_codeAction: #{
    \       defaultAction: 'apply',
    \     }
    \   },
    \   uiParams: #{
    \     ff: #{
    \       split: 'floating',
    \       floatingTitle: 'Result',
    \       floatingTitlePos: 'center',
    \       floatingBorder: 'rounded',
    \       prompt: '',
    \       displaySourceName: 'none',
    \       autoAction: #{
    \         name: 'preview',
    \       },
    \       startAutoAction: v:true,
    \       filterFloatingPosition: 'top',
    \       filterSplitDirection: 'floating',
    \       filterFloatingTitle: 'Search',
    \       filterFloatingTitlePos: 'center',
    \       previewFloating: v:true,
    \       previewSplit: 'vertical',
    \       previewWindowOptions: [
    \         ["&signcolumn", "no"],
    \         ["&foldcolumn", 0],
    \         ["&foldenable", 0],
    \         ["&number", 0],
    \         ["&wrap", 0],
    \         ["&scrolloff", 0],
    \       ],
    \       previewFloatingBorder: 'rounded',
    \       previewFloatingTitle: 'Preview',
    \       previewFloatingTitlePos: 'center',
    \       highlights: #{
    \       },
    \       ignoreEmpty: v:true
    \     },
    \   },
    \ })

function s:resize_ddu_ff_window() abort
  let filterHeight = 3
  let space = 3

  let height = float2nr(&lines * 0.8)
  let row = float2nr(&lines * 0.1)

  let full_width = float2nr(&columns * 0.8)
  let width = float2nr(full_width / 2)
  let col = float2nr(&columns * 0.1)

  let previewWidth = float2nr(width / 2)

  hi Tofu guifg=#ffffff guibg=#272727

  call cmdline#set_option(#{
        \   width: width - float2nr(space / 2),
        \   col: col,
        \   row: row,
        \   border: 'rounded',
        \   highlight_cursor: 'Tofu',
        \ })

  call ddu#custom#patch_global(#{
    \   uiParams: #{
    \     ff: #{
    \       winHeight: height - filterHeight,
    \       winRow: row + filterHeight,
    \       winWidth: width - float2nr(space / 2),
    \       winCol: col,
    \       previewHeight: height,
    \       previewRow: row,
    \       previewWidth: width,
    \       previewCol: col + width + float2nr(space / 2),
    \     }
    \   }
    \ })

endfunction

call s:resize_ddu_ff_window()

autocmd VimResized * call s:resize_ddu_ff_window()

" ddu-ui-ffを開いたときにフィルターを開く
" autocmd User Ddu:uiReady
"       \ : if &l:filetype ==# 'ddu-ff'
"       \ |   call ddu#ui#do_action('openFilterWindow')
"       \ | endif

autocmd User Ddu:ui:ff:openFilterWindow call cmdline#enable()

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> <ESC>
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> v
        \ <Cmd>call ddu#ui#do_action('preview')<CR>
endfunction

call ddu#custom#patch_local('fd-file_rec', #{
    \   sources: [
    \     #{ name: 'file_external'}
    \   ],
    \   sourceParams: #{
    \     file_external: #{
    \       cmd: ['fd', '.', '-H', '-t', 'f'],
    \       updateItems: 1000,
    \     },
    \   },
    \ })

call ddu#custom#patch_local('grep', #{
    \   uiParams: #{
    \     ff: #{
    \       ignoreEmpty: v:false,
    \       autoResize: v:false,
    \     },
    \   },
    \   sources: [#{ name: 'rg', options: #{ volatile: v:true } } ],
    \   sourceParams: #{
    \     rg: #{
    \       args: ['--threads', '4', '--column', '--no-heading', '--color', 'never', '--json', '--hidden'],
    \     },
    \   },
    \ })

call ddu#custom#patch_local('file_rec', #{
    \   sources: [#{ name: 'file_rec' }],
    \ })

" ddu-source-lsp {{{

for [name, method] in [
      \ ['lsp:definition', 'textDocument/definition'],
      \ ['lsp:type_definition', 'textDocument/typeDefinition'],
      \ ['lsp:declaration', 'textDocument/declaration'],
      \ ['lsp:implementation', 'textDocument/implementation'],
      \ ]

  call ddu#custom#patch_local(name, #{
        \   sources: [
        \     #{ name: 'lsp_definition', params: #{ method: method } }
        \   ],
        \   sourceOptions: #{
        \     lsp: #{
        \       matchers: ['matcher_fzf'],
        \     },
        \   },
        \   sync: v:true,
        \ })
endfor

call ddu#custom#patch_local('lsp:code_action', #{
    \   sources: [
    \     #{ name: 'lsp_codeAction' }
    \   ],
    \ })

call ddu#custom#patch_local('lsp:references', #{
    \   sources: [
    \     #{ name: 'lsp_references' }
    \   ],
    \ })

call ddu#custom#patch_local('lsp:document_symbol', #{
    \   sources: [
    \     #{ name: 'lsp_documentSymbol' }
    \   ],
    \   sourceOptions: #{
    \     lsp_documentSymbol: #{
    \       matchers: ['matcher_fzf'],
    \       converters: ['converter_lsp_symbol'],
    \     },
    \   }
    \ })

call ddu#custom#patch_local('lsp:workspace_symbol', #{
    \   sources: [
    \     #{ name: 'lsp_workspaceSymbol' }
    \   ],
    \   sourceOptions: #{
    \     lsp: #{
    \       volatile: v:true,
    \     },
    \     lsp_workspaceSymbol: #{
    \       matchers: ['matcher_fzf'],
    \       converters: ['converter_lsp_symbol'],
    \     },
    \   }
    \ })

call ddu#custom#patch_local('lsp:diagnostic', #{
    \   sources: [
    \     #{ name: 'lsp_diagnostic' }
    \   ],
    \   sourceOptions: #{
    \     lsp_diagnostic: #{
    \       matchers: ['matcher_fzf'],
    \       converters: ['converter_lsp_diagnostic'],
    \     },
    \   }
    \ })

" }}}

" ddu-filer {{{
call ddu#custom#patch_local('filer', #{
    \   ui: 'filer',
    \   sources: [
    \     #{ name: 'file' }
    \   ],
    \   sourceOptions: #{
    \     file: #{
    \       sorters: ['sorter_alpha', 'sorter_directory_file'],
    \     },
    \   },
    \   uiParams: #{
    \     filer: #{
    \       split: 'floating',
    \       previewFloating: v:true,
    \       floatingBorder: 'rounded',
    \       floatingTitle: 'Filer',
    \       floatingTitlePos: 'center',
    \       previewFloatingBorder: 'rounded',
    \       previewSplit: 'vertical',
    \       highlights: #{
    \       }
    \     },
    \   },
    \   actionOptions: #{
    \     narrow: #{
    \       quit: v:false,
    \     },
    \   },
    \   columnParams: #{
    \     icon_filename: #{
    \       pathDisplayOption: "basename",
    \     }
    \   },
    \ })

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  nnoremap <buffer><expr> <CR>
        \ ddu#ui#get_item()->get('isTree', v:false) ?
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{name: 'narrow'})<CR>" :
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{name: 'open'})<CR>"
  nnoremap <buffer><silent> <ESC> <Cmd>quit<CR>
  nnoremap <buffer><silent> v
        \ <Cmd>call ddu#ui#do_action('preview')<CR>
  nnoremap <buffer><silent> <BS>
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'narrow', params: #{path: '..'}})<CR>
  nnoremap <buffer><silent> nf
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'newFile'})<CR>
  nnoremap <buffer><silent> nd
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'newDirectory'})<CR>
  nnoremap <buffer><silent> dd
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'move'})<CR>
  nnoremap <buffer><silent> rn
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'rename'})<CR>
  nnoremap <buffer><silent> rm
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'trash'})<CR>
  nnoremap <buffer><silent> u
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'undo'})<CR>
  nnoremap <buffer><silent> yy
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'copy'})<CR>
  nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'paste'})<CR>
endfunction
" }}}

" }}}
