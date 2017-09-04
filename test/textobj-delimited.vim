scriptencoding utf-8
let s:suite = themis#suite('textobj-delimited')

function! s:runtest(test) abort "{{{
  call setline(1, a:test.field)
  call cursor(a:test.cursor)
  let input = &selection ==# 'inclusive' ? a:test.input : get(a:test, 'input_e', a:test.input)
  let @@ = ''
  execute 'normal ' . input
  let got = @@
  let message = printf(
        \   "field : %s\ncursor: %s\ninput : %s\nselection: %s",
        \   a:test.field,
        \   a:test.cursor,
        \   input,
        \   &selection)
  call g:assert.equals(got, a:test.expect, message)
endfunction
"}}}

function! s:forward_i() abort "{{{
  let testset = []

  " one or two delimiters
  let testset += [
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'yid',  'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'yid',  'expect': 'def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'yid',  'expect': 'def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'yid',  'expect': 'abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'yid',  'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'yid',  'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'vidy', 'expect': 'def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'vidy', 'expect': 'def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'vidy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'vidy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'vidy', 'expect': 'ghi'},
        \ ]

  " more delimiters
  let testset += [
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'yid',  'expect': 'def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'yid',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'yid',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'yid',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'yid',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'yid',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'yid',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'yid',  'expect': 'jkl'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'vidy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'vidy', 'expect': 'ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'vidy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'vidy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'vidy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'vidy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'vidy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'vidy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'vidy', 'expect': 'jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_i_count() abort "{{{
  " counts
  let testset = [
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y1id',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y2id',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y3id',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y4id',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y5id',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v1idy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v2idy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v3idy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v4idy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v5idy', 'expect': 'jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_i_expand() abort "{{{
  " expanding selection
  let testset = [
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vididy', 'expect': 'abc_def'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vidididy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vididididy', 'expect': 'abc_def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vidididididy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vididididididy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3ididy', 'expect': 'ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3idididy', 'expect': 'ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3ididididy', 'expect': 'ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 5], 'input': 'v2lidy', 'input_e': 'v3lidy', 'expect': 'def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3lidy', 'input_e': 'v4lidy', 'expect': '_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vid2idy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vid3idy', 'expect': 'abc_def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vid4idy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vid5idy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3l2idy', 'input_e': 'v4l2idy', 'expect': '_def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3l3idy', 'input_e': 'v4l3idy', 'expect': '_def_ghi_jkl_mno'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_i_on_delimiter() abort "{{{
  " cursor is on a delimiter
  let testset = [
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'yid',  'expect': 'def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'vidy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'vidy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'yid',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'yid',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'yid',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'vidy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'vidy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'vidy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'vidy', 'expect': 'ghi'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}

function! s:forward_a() abort "{{{
  let testset = []

  " one or two delimiters
  let testset += [
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'yad',  'expect': 'abc_'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'yad',  'expect': '_abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'yad',  'expect': 'abc_'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'yad',  'expect': '_def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'yad',  'expect': 'abc_'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'yad',  'expect': '_def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'yad',  'expect': '_abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'yad',  'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'yad',  'expect': 'abc_'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'yad',  'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'vady', 'expect': 'abc_'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'vady', 'expect': '_abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'vady', 'expect': 'abc_'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'vady', 'expect': '_def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'vady', 'expect': 'abc_'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'vady', 'expect': '_def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'vady', 'expect': '_abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'vady', 'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'vady', 'expect': 'abc_'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'vady', 'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'vady', 'expect': '_ghi'},
        \ ]

  " more delimiters
  let testset += [
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'yad',  'expect': 'abc_'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'yad',  'expect': '_def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'yad',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'yad',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'yad',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'yad',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'yad',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'yad',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'yad',  'expect': '_jkl'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'vady', 'expect': 'abc_'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'vady', 'expect': '_def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'vady', 'expect': '_ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'vady', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'vady', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'vady', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'vady', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'vady', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'vady', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'vady', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'vady', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'vady', 'expect': '_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_a_count() abort "{{{
  " counts
  let testset = [
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y1ad',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y2ad',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y3ad',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y4ad',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y5ad',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v1ady', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v2ady', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v3ady', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v4ady', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v5ady', 'expect': '_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_a_expand() abort "{{{
  " expanding selection
  let testset = [
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vadady', 'expect': 'abc_def_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vadadady', 'expect': 'abc_def_ghi_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vadadadady', 'expect': 'abc_def_ghi_jkl_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vadadadadady', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vadadadadadady', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3adady', 'expect': '_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3adadady', 'expect': '_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'v3adadadady', 'expect': '_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 5], 'input': 'v2lady', 'input_e': 'v3lady', 'expect': 'def_ghi_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3lady', 'input_e': 'v4lady', 'expect': '_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vad2ady', 'expect': 'abc_def_ghi_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vad3ady', 'expect': 'abc_def_ghi_jkl_'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vad4ady', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 1], 'input': 'vad5ady', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3l2ady', 'input_e': 'v4l2ady', 'expect': '_def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 4], 'input': 'v3l3ady', 'input_e': 'v4l3ady', 'expect': '_def_ghi_jkl_mno'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:forward_a_on_delimiter() abort "{{{
  " cursor is on a delimiter
  let testset = [
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'yad',  'expect': '_def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'vady', 'expect': '_def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'vady', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'yad',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'yad',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'yad',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'vady', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'vady', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'vady', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'vady', 'expect': '_ghi'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}

function! s:backward_i() abort "{{{
  let testset = []

  " one or two delimiters
  let testset += [
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'yiD',  'expect': 'def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'yiD',  'expect': 'def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'yiD',  'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'yiD',  'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'viDy', 'expect': 'def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'viDy', 'expect': 'def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'viDy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'viDy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'viDy', 'expect': 'ghi'},
        \ ]

  " more delimiters
  let testset += [
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'yiD',  'expect': 'def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'yiD',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'yiD',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'yiD',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'yiD',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'yiD',  'expect': 'jkl'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'viDy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'viDy', 'expect': 'ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'viDy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'viDy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'viDy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'viDy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'viDy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'viDy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'viDy', 'expect': 'jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_i_count() abort "{{{
  " counts
  let testset = [
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y1iD',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y2iD',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y3iD',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y4iD',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y5iD',  'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v1iDy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v2iDy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v3iDy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v4iDy', 'expect': 'jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v5iDy', 'expect': 'jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_i_expand() abort "{{{
  " expanding selection
  let testset = [
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viDiDy', 'expect': 'jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viDiDiDy', 'expect': 'ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viDiDiDiDy', 'expect': 'def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viDiDiDiDiDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viDiDiDiDiDiDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3iDiDy', 'expect': 'def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3iDiDiDy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3iDiDiDiDy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v2liDy', 'input_e': 'v3liDy', 'expect': 'jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3liDy', 'input_e': 'v4liDy', 'expect': 'ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viD2iDy', 'expect': 'ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viD3iDy', 'expect': 'def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viD4iDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'viD5iDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3l2iDy', 'input_e': 'v4l2iDy', 'expect': 'def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3l3iDy', 'input_e': 'v4l3iDy', 'expect': 'abc_def_ghi_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_i_on_delimiter() abort "{{{
  " cursor is on a delimiter
  let testset = [
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'yiD',  'expect': 'def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'viDy', 'expect': 'def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'viDy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'yiD',  'expect': 'abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'yiD',  'expect': 'def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'yiD',  'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'viDy', 'expect': 'abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'viDy', 'expect': 'def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'viDy', 'expect': 'ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'viDy', 'expect': 'ghi'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}

function! s:backward_a() abort "{{{
  let testset = []

  " one or two delimiters
  let testset += [
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'yaD',  'expect': 'abc_'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'yaD',  'expect': '_abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'yaD',  'expect': 'abc_'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'yaD',  'expect': '_def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'yaD',  'expect': 'abc_'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'yaD',  'expect': '_def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'yaD',  'expect': '_abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'yaD',  'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'yaD',  'expect': 'abc_'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'yaD',  'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': 'abc_',        'cursor': [1, 1], 'input': 'vaDy', 'expect': 'abc_'},
        \   {'field': '_abc',        'cursor': [1, 2], 'input': 'vaDy', 'expect': '_abc'},
        \   {'field': 'abc_def',     'cursor': [1, 1], 'input': 'vaDy', 'expect': 'abc_'},
        \   {'field': 'abc_def',     'cursor': [1, 5], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': 'abc_def_',    'cursor': [1, 1], 'input': 'vaDy', 'expect': 'abc_'},
        \   {'field': 'abc_def_',    'cursor': [1, 5], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': '_abc_def',    'cursor': [1, 2], 'input': 'vaDy', 'expect': '_abc'},
        \   {'field': '_abc_def',    'cursor': [1, 6], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 1], 'input': 'vaDy', 'expect': 'abc_'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 5], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': 'abc_def_ghi', 'cursor': [1, 9], 'input': 'vaDy', 'expect': '_ghi'},
        \ ]

  " more delimiters
  let testset += [
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'yaD',  'expect': 'abc_'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'yaD',  'expect': '_def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'yaD',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'yaD',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'yaD',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'yaD',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'yaD',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'yaD',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'yaD',  'expect': '_jkl'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  1], 'input': 'vaDy', 'expect': 'abc_'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  5], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1,  9], 'input': 'vaDy', 'expect': '_ghi'},
        \   {'field': 'abc_def_ghi_jkl',   'cursor': [1, 13], 'input': 'vaDy', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  2], 'input': 'vaDy', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1,  6], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 10], 'input': 'vaDy', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl',  'cursor': [1, 14], 'input': 'vaDy', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  2], 'input': 'vaDy', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1,  6], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 10], 'input': 'vaDy', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 14], 'input': 'vaDy', 'expect': '_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_a_count() abort "{{{
  " counts
  let testset = [
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y1aD',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y2aD',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y3aD',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y4aD',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'y5aD',  'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v1aDy', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v2aDy', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v3aDy', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v4aDy', 'expect': '_jkl'},
        \   {'field': '_abc_def_ghi_jkl_', 'cursor': [1, 1], 'input': 'v5aDy', 'expect': '_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_a_expand() abort "{{{
  " expanding selection
  let testset = [
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaDaDy', 'expect': '_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaDaDaDy', 'expect': '_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaDaDaDaDy', 'expect': '_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaDaDaDaDaDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaDaDaDaDaDaDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3aDaDy', 'expect': '_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3aDaDaDy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'v3aDaDaDaDy', 'expect': 'abc_def_ghi'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v2laDy', 'input_e': 'v3laDy', 'expect': '_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3laDy', 'input_e': 'v4laDy', 'expect': '_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaD2aDy', 'expect': '_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaD3aDy', 'expect': '_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaD4aDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 17], 'input': 'vaD5aDy', 'expect': 'abc_def_ghi_jkl_mno'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3l2aDy', 'input_e': 'v4l2aDy', 'expect': '_def_ghi_jkl'},
        \   {'field': 'abc_def_ghi_jkl_mno', 'cursor': [1, 12], 'input': 'v3l3aDy', 'input_e': 'v4l3aDy', 'expect': 'abc_def_ghi_jkl'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}
function! s:backward_a_on_delimiter() abort "{{{
  " cursor is on a delimiter
  let testset = [
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'yaD',  'expect': '_def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  4], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': 'abc_def_ghi',   'cursor': [1,  8], 'input': 'vaDy', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'yaD',  'expect': '_abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'yaD',  'expect': '_def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'yaD',  'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  1], 'input': 'vaDy', 'expect': '_abc'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  5], 'input': 'vaDy', 'expect': '_def'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1,  9], 'input': 'vaDy', 'expect': '_ghi'},
        \   {'field': '_abc_def_ghi_', 'cursor': [1, 13], 'input': 'vaDy', 'expect': '_ghi'},
        \ ]

  for test in testset
    call s:runtest(test)
  endfor
endfunction
"}}}



function! s:suite.forward_i() dict abort "{{{
  set selection=inclusive
  call s:forward_i()
  set selection=exclusive
  call s:forward_i()
  set selection&
endfunction
"}}}
function! s:suite.forward_i_count() dict abort "{{{
  set selection=inclusive
  call s:forward_i_count()
  set selection=exclusive
  call s:forward_i_count()
  set selection&
endfunction
"}}}
function! s:suite.forward_i_expand() dict abort "{{{
  set selection=inclusive
  call s:forward_i_expand()
  set selection=exclusive
  call s:forward_i_expand()
  set selection&
endfunction
"}}}
function! s:suite.forward_i_on_delimiter() dict abort "{{{
  set selection=inclusive
  call s:forward_i_on_delimiter()
  set selection=exclusive
  call s:forward_i_on_delimiter()
  set selection&
endfunction
"}}}

function! s:suite.forward_a() dict abort "{{{
  set selection=inclusive
  call s:forward_a()
  set selection=exclusive
  call s:forward_a()
  set selection&
endfunction
"}}}
function! s:suite.forward_a_count() dict abort "{{{
  set selection=inclusive
  call s:forward_a_count()
  set selection=exclusive
  call s:forward_a_count()
  set selection&
endfunction
"}}}
function! s:suite.forward_a_expand() dict abort "{{{
  set selection=inclusive
  call s:forward_a_expand()
  set selection=exclusive
  call s:forward_a_expand()
  set selection&
endfunction
"}}}
function! s:suite.forward_a_on_delimiter() dict abort "{{{
  set selection=inclusive
  call s:forward_a_on_delimiter()
  set selection=exclusive
  call s:forward_a_on_delimiter()
  set selection&
endfunction
"}}}

function! s:suite.backward_i() dict abort "{{{
  set selection=inclusive
  call s:backward_i()
  set selection=exclusive
  call s:backward_i()
  set selection&
endfunction
"}}}
function! s:suite.backward_i_count() dict abort "{{{
  set selection=inclusive
  call s:backward_i_count()
  set selection=exclusive
  call s:backward_i_count()
  set selection&
endfunction
"}}}
function! s:suite.backward_i_expand() dict abort "{{{
  set selection=inclusive
  call s:backward_i_expand()
  set selection=exclusive
  call s:backward_i_expand()
  set selection&
endfunction
"}}}
function! s:suite.backward_i_on_delimiter() dict abort "{{{
  set selection=inclusive
  call s:backward_i_on_delimiter()
  set selection=exclusive
  call s:backward_i_on_delimiter()
  set selection&
endfunction
"}}}

function! s:suite.backward_a() dict abort "{{{
  set selection=inclusive
  call s:backward_a()
  set selection=exclusive
  call s:backward_a()
  set selection&
endfunction
"}}}
function! s:suite.backward_a_count() dict abort "{{{
  set selection=inclusive
  call s:backward_a_count()
  set selection=exclusive
  call s:backward_a_count()
  set selection&
endfunction
"}}}
function! s:suite.backward_a_expand() dict abort "{{{
  set selection=inclusive
  call s:backward_a_expand()
  set selection=exclusive
  call s:backward_a_expand()
  set selection&
endfunction
"}}}
function! s:suite.backward_a_on_delimiter() dict abort "{{{
  set selection=inclusive
  call s:backward_a_on_delimiter()
  set selection=exclusive
  call s:backward_a_on_delimiter()
  set selection&
endfunction
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
