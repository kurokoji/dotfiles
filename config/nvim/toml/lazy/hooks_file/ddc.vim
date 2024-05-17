" hook_source {{{
call ddc#custom#patch_global(#{
      \   ui: 'pum',
      \   sources: ['copilot', 'lsp', 'neosnippet', 'around', 'buffer', 'file'],
      \   sourceOptions: #{
      \     _: #{
      \       matchers: ['matcher_head'],
      \       sorters: ['sorter_rank']
      \     },
      \     around: #{
      \       mark: '[A]',
      \     },
      \     necovim: #{
      \       mark: '[NECO]',
      \     },
      \     cmdline: #{
      \       mark: '[CMD]',
      \     },
      \     cmdline-history: #{
      \       mark: '[CMD-H]',
      \     },
      \     input: #{
      \       mark: '[I]',
      \       isVolatile: v:true,
      \     },
      \     lsp: #{
      \       matchers: ['matcher_head'],
      \       converters: ['converter_kind_labels'],
      \       sorters: ['sorter_lsp-kind'],
      \       mark: '[LSP]',
      \       forceCompletionPattern: '\.\w*|:\w*|->\w*',
      \     },
      \     file: #{
      \       mark: '[FILE]',
      \       isVolatile: v:true,
      \       forceCompletionPattern: '\S/\S*'
      \     },
      \     neosnippet: #{
      \       mark: '[SNIP]',
      \     },
      \     buffer: #{
      \       mark: '[BUF]',
      \     },
      \     copilot: #{
      \       mark: '[AI]',
      \       matchers: ['matcher_head'],
      \       minAutoCompleteLength: 0,
      \     },
      \   },
      \   sourceParams: #{
      \     around: #{
      \       maxSize: 500,
      \     },
      \     path: #{
      \       cmd: ['find', '-maxdepth', '5']
      \     },
      \     buffer: #{
      \       requireSameFiletype: v:false,
      \       limitBytes: 5000000,
      \       fromAltBuf: v:true,
      \       forceCollect: v:true,
      \     },
      \     lsp: #{
      \       enableResolveItem: v:true,
      \       enableAdditionalTextEdit: v:true,
      \       confirmBehavior: "replace",
      \       lspEngine: "nvim-lsp",
      \     }
      \   },
      \   filterParams: #{
      \     sorter_lsp-kind: #{
      \       priority: [
      \         'Enum',
      \         ['Method', 'Function'],
      \         'Field',
      \         'Variable',
      \       ]
      \     },
      \     converter_kind_labels: #{
      \       kindLabels: #{
      \         Text: "",
      \         Method: "",
      \         Function: "",
      \         Constructor: "",
      \         Field: "",
      \         Variable: "",
      \         Class: "",
      \         Interface: "",
      \         Module: "",
      \         Property: "",
      \         Unit: "",
      \         Value: "",
      \         Enum: "",
      \         Keyword: "",
      \         Snippet: "",
      \         Color: "",
      \         File: "",
      \         Reference: "",
      \         Folder: "",
      \         EnumMember: "",
      \         Constant: "",
      \         Struct: "",
      \         Event: "",
      \         Operator: "",
      \         TypeParameter: ""
      \       },
      \       kindHlGroups: #{
      \         Method: "Function",
      \         Function: "Function",
      \         Constructor: "Function",
      \         Field: "Identifier",
      \         Variable: "Identifier",
      \         Class: "Structure",
      \         Interface: "Structure"
      \       }
      \     }
      \   }
      \ })

call ddc#custom#patch_global('autoCompleteEvents', [
    \ 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged',
    \ ])

call ddc#custom#patch_global('cmdlineSources', {
    \ ':': ['cmdline-history', 'cmdline', 'file', 'around'],
    \ '@': ['cmdline-history', 'input', 'file', 'around'],
    \ '>': ['cmdline-history', 'input', 'file', 'around'],
    \ '/': ['around', 'line'],
    \ '?': ['around', 'line'],
    \ '-': ['around', 'line'],
    \ '=': ['input'],
    \ })

augroup ddc_cmdline
  autocmd!
  autocmd CmdlineEnter * call CommandlinePre()
augroup END

" nnoremap : <Cmd>call CommandlinePre()<CR>:
" nnoremap ; <Cmd>call CommandlinePre()<CR>:
" nnoremap / <Cmd>call CommandlinePre()<CR>/
" nnoremap ? <Cmd>call CommandlinePre()<CR>?

function! CommandlinePre() abort
  " Note: It disables default command line completion!
  cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
  cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
  cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
  cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
  cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
  cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
  cnoremap <silent><expr> <CR>
        \ pum#visible() && pum#entered() ? '<Cmd>call pum#map#confirm()<CR>' :
        \ '<CR>'

  " Overwrite sources
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()
  " autocmd InsertEnter <buffer> ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction

function! CommandlinePost() abort
  silent! cunmap <Tab>
  silent! cunmap <S-Tab>
  silent! cunmap <C-n>
  silent! cunmap <C-p>
  silent! cunmap <C-y>
  silent! cunmap <C-e>
  silent! cunmap <CR>

  " Restore sources
  if exists('b:prev_buffer_config')
    " call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif
endfunction

call ddc#enable()
" }}}
