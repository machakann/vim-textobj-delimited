" Vim global plugin to define text-object for delimited words
" Last Change: 18-May-2014.
" Maintainer : Masaaki Nakamura <mckn@outlook.com>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

if exists("g:loaded_textobj_delimited")
  finish
endif
let g:loaded_delimited = 1

call textobj#user#plugin('delimited', {
      \   'forward': {
      \     'select-a-function': 'textobj#delimited#a',
      \     'select-a': 'ad',
      \     'select-i-function': 'textobj#delimited#i',
      \     'select-i': 'id',
      \   },
      \   'backward': {
      \     'select-a-function': 'textobj#delimited#A',
      \     'select-a': '',
      \     'select-i-function': 'textobj#delimited#I',
      \     'select-i': '',
      \   },
      \ })

