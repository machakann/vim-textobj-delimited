" Vim global plugin to define text-object for delimited words
" Last Change: 04-Jul-2014.
" Maintainer : Masaaki Nakamura <mckn@outlook.com>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if exists("g:loaded_textobj_delimited")
  finish
endif
let g:loaded_delimited = 1

onoremap <silent> <Plug>(textobj-delimited-forward-i)  :<C-u>call textobj#delimited#i('o')<CR>
xnoremap <silent> <Plug>(textobj-delimited-forward-i)  :<C-u>call textobj#delimited#i('v')<CR>
onoremap <silent> <Plug>(textobj-delimited-forward-a)  :<C-u>call textobj#delimited#a('o')<CR>
xnoremap <silent> <Plug>(textobj-delimited-forward-a)  :<C-u>call textobj#delimited#a('v')<CR>
onoremap <silent> <Plug>(textobj-delimited-backward-i) :<C-u>call textobj#delimited#I('o')<CR>
xnoremap <silent> <Plug>(textobj-delimited-backward-i) :<C-u>call textobj#delimited#I('v')<CR>
onoremap <silent> <Plug>(textobj-delimited-backward-a) :<C-u>call textobj#delimited#A('o')<CR>
xnoremap <silent> <Plug>(textobj-delimited-backward-a) :<C-u>call textobj#delimited#A('v')<CR>

""" default keymappings
" If g:textobj_delimited_no_default_key_mappings has been defined, then quit immediately.
if exists('g:textobj_delimited_no_default_key_mappings') | finish | endif

" forward
if !hasmapto('<Plug>(textobj-delimited-forward-i)')
  silent! xmap <unique> id <Plug>(textobj-delimited-forward-i)
  silent! omap <unique> id <Plug>(textobj-delimited-forward-i)
endif

if !hasmapto('<Plug>(textobj-delimited-forward-a)')
  silent! xmap <unique> ad <Plug>(textobj-delimited-forward-a)
  silent! omap <unique> ad <Plug>(textobj-delimited-forward-a)
endif


" backward
if !hasmapto('<Plug>(textobj-delimited-backward-i)')
  silent! xmap <unique> iD <Plug>(textobj-delimited-backward-i)
  silent! omap <unique> iD <Plug>(textobj-delimited-backward-i)
endif

if !hasmapto('<Plug>(textobj-delimited-backward-a)')
  silent! xmap <unique> aD <Plug>(textobj-delimited-backward-a)
  silent! omap <unique> aD <Plug>(textobj-delimited-backward-a)
endif
