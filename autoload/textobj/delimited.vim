" textobj-delimited
" text-object for treating a delimited part of a word by {count}
" The words like, foo_bar_baz, foo#bar#baz, FooBarBaz, are expected target.

" The meaning of {count} is unique for this text-object, that is, different
" from ordinary text-object.
" For example:
"------------------------------------------------
" key input: did
"  #                    #         : cursor
" 'foo_bar_baz'   ->   '_bar_baz'
"------------------------------------------------
" key input: did
"      #                    #     : cursor
" 'foo_bar_baz'   ->   'foo__baz'
"------------------------------------------------
" key input: did
"          #                   #  : cursor
" 'foo_bar_baz'   ->   'foo_bar_'
"------------------------------------------------
" key input: d1id
"      #                #         : cursor
" 'foo_bar_baz'   ->   '_bar_baz'
"------------------------------------------------
" key input: d2id
"  #                        #     : cursor
" 'foo_bar_baz'   ->   'foo__baz'
"------------------------------------------------
" key input: d3id
"  #                           #  : cursor
" 'foo_bar_baz'   ->   'foo_bar_'
"------------------------------------------------
" key input: dad
"  #                    #         : cursor
" 'foo_bar_baz'   ->   'bar_baz'
"------------------------------------------------
" key input: dad
"      #                    #     : cursor
" 'foo_bar_baz'   ->   'foo_baz'
"------------------------------------------------
" key input: dad
"          #                  #   : cursor
" 'foo_bar_baz'   ->   'foo_bar'
"------------------------------------------------
" key input: d1ad
"      #                #         : cursor
" 'foo_bar_baz'   ->   'bar_baz'
"------------------------------------------------
" key input: d2ad
"  #                        #     : cursor
" 'foo_bar_baz'   ->   'foo_baz'
"------------------------------------------------
" key input: d3ad
"  #                          #   : cursor
" 'foo_bar_baz'   ->   'foo_bar'
"------------------------------------------------

let s:save_cpo = &cpo
set cpo&vim

" default pattern
let s:textobj_delimited_patterns = [
      \ ['-', '\<\%(-\k\+\|\k\+-\)\%(\k*-\?\)*\>'],
      \ ['#', '\<\%(#\k\+\|\k\+#\)\%(\k*#\?\)*\>'],
      \ ['_', '\<\%(_\k\+\|\k\+_\)\%(\k*_\?\)*\>'],
      \ ['\C\ze[A-Z]', '\C\<[A-Z]\?\k\+[A-Z]\%(\k*[A-Z]\?\)*\>'],
      \ ]

function! textobj#delimited#i()
  return s:prototype('i')
endfunction

function! textobj#delimited#a()
  return s:prototype('a')
endfunction

function! textobj#delimited#I()
  return s:prototype('I')
endfunction

function! textobj#delimited#A()
  return s:prototype('A')
endfunction

function! s:prototype(kind) "{{{
  let l:count  = v:count1
  let orig_pos = [line('.'), col('.')]
  let string   = getline(orig_pos[0])

  " user configuration
  let opt_patterns = s:user_conf('textobj_delimited_patterns', [])

  " choose patterns
  let patterns = (opt_patterns != []) ? opt_patterns : s:textobj_delimited_patterns

  let candidates = []
  " search for the head and tail of a delimited word
  for pattern in patterns
    let delimiter = pattern[0]
    let delimited = pattern[1]

    if a:kind =~# '[ia]'
      let flag = 'ce'
    elseif a:kind =~# '[IA]'
      let flag = 'bc'
    endif

    while 1
      if a:kind =~# '[ia]'
        let tail = searchpos(delimited,  flag, orig_pos[0])
        let head = searchpos(delimited, 'bcn', orig_pos[0])
        let flag = 'e'
      elseif a:kind =~# '[IA]'
        let head = searchpos(delimited,  flag, orig_pos[0])
        let tail = searchpos(delimited, 'cen', orig_pos[0])
        let flag = 'b'
      endif

      if tail == [0, 0]
        " no candidate
        break
      elseif head == tail
        " one character cannot be a delimited ward!
        continue
      endif

      let body = string[head[1]-1 : tail[1]-1]

      let candidates += [[delimiter, body, head[1], tail[1]]]
      break
    endwhile

    call cursor(orig_pos)
  endfor

  " if any candidate could not be found, then quit.
  if candidates == [] | return 0 | endif

  " check whether the cursor is on a delimited word.
  let filtered = filter(copy(candidates), '(v:val[2] <= orig_pos[1]) && (v:val[3] >= orig_pos[1])')

  if filtered == []
    " if the cursor is not on the word, then searching forward inside the line
    " and choose the closest one.
    if a:kind =~# '[ai]'
      let heads  = map(copy(candidates), 'v:val[2]')
      let target = candidates[match(heads, sort(copy(heads))[0])]
    elseif a:kind =~# '[AI]'
      let heads  = map(copy(candidates), 'v:val[3]')
      let target = candidates[match(heads, reverse(sort(copy(heads)))[0])]
    endif
  else
    " if the cursor is on the word, then choose the shortest candidate.
    let candidates = filtered
    let lengths    = map(copy(candidates), 'v:val[3]-v:val[2]')
    let target     = candidates[match(lengths, sort(copy(lengths))[0])]
  endif

  if (filtered != []) && (v:count == 0)
    let [start_pos, end_pos] = s:search_destination(a:kind, orig_pos, l:count, target, 1)
  else
    let [start_pos, end_pos] = s:search_destination(a:kind, orig_pos, l:count, target, 0)
  endif

  return ['v', start_pos, end_pos]
endfunction
"}}}
function! s:user_conf(name, default)    "{{{
  let user_conf = a:default

  if exists('g:textobj_functioncall_' . a:name)
    let user_conf = g:textobj_functioncall_{a:name}
  endif

  if exists('t:textobj_functioncall_' . a:name)
    let user_conf = t:textobj_functioncall_{a:name}
  endif

  if exists('w:textobj_functioncall_' . a:name)
    let user_conf = w:textobj_functioncall_{a:name}
  endif

  if exists('b:textobj_functioncall_' . a:name)
    let user_conf = b:textobj_functioncall_{a:name}
  endif

  return user_conf
endfunction
"}}}
function! s:search_destination(kind, orig_pos, count, target, get_the_part_under_the_cursor) "{{{
  let split_parts = s:parse(a:target[1], a:target[0])

  let n     = 0
  let start = -1
  let end   = -1
  if a:get_the_part_under_the_cursor
    for part in split_parts
      if (a:orig_pos[1] <= a:target[2] + part[2])
        if a:kind ==? 'i'
          let start = part[1]
          let end   = part[2]
        elseif a:kind ==? 'a'
          let start = part[0]
          let end   = part[3]
        endif

        break
      endif
    endfor
  else
    let idx   = (len(split_parts) < a:count) ? (len(split_parts) - 1) : (a:count - 1)

    if a:kind ==? 'i'
      let start = split_parts[idx][1]
      let end   = split_parts[idx][2]
    elseif a:kind ==? 'a'
      let start = split_parts[idx][0]
      let end   = split_parts[idx][3]
    endif
  endif

  let start_pos = [0, a:orig_pos[0], a:target[2] + start, 0]
  let end_pos   = [0, a:orig_pos[0], a:target[2] + end  , 0]

  return [start_pos, end_pos]
endfunction
"}}}
function! s:parse(string, delimiter)  "{{{
  let head = -1
  let tail = 0

  let pos = []
  while 1
    if head == tail
      " for the case of zero-width match delimiter
      let tail += 1
    endif

    let head = match(a:string, a:delimiter, tail)

    if head == -1 | break | endif

    let tail = matchend(a:string, a:delimiter, tail)

    let pos += [[head, tail]]
  endwhile

  if pos == []
    return [[0, 0, len(a:string) - 1, len(a:string) - 1]]
  endif

  let parts = []

  " parts = [
  "           head_delimiter_start,
  "           delimited_word_start,
  "           delimited_word_end,
  "           tail_delimiter_end
  "         ]

  let i = 0
  let n = len(pos)
  let f = [0, 0, 0, 0]
  for p in pos
    let i += 1

    if i == 1
      " first delimiter
      if n == 1
        " also the last
        if p[1] != len(a:string)
          if p[0] != 0
            " case like: 'abc_def'
            let parts += [[0, 0, p[0] - 1, p[1] - 1]]
            let parts += [[p[0], p[1], len(a:string) - 1, len(a:string) - 1]]
          else
            " case like: '_abc'
            let parts += [[0, p[1], len(a:string) - 1, len(a:string) - 1]]
          endif
        else
          " case like: 'abc_'
          let parts += [[0, 0, p[0] - 1, p[1] - 1]]
        endif
      else
        if p[0] != 0
          " case like: 'abc_...'
          let parts += [[0, 0, p[0] - 1, p[1] - 1]]
          let f[0:1] = [p[0], p[1]]
        else
          " case like: '_abc_...'
          let f[0:1] = [0, p[1]]
        endif
      endif
    elseif i == 2
      if n == 2
        if p[1] != len(a:string)
          if f[0] == 0
            " case like: '_abc_def'
            let f[2:3] = [p[0] - 1, p[1] - 1]
            let parts += [copy(f)]
            let parts += [[p[0], p[1], len(a:string) - 1, len(a:string) - 1]]
          else
            " case like: 'abc_def_ghi'
            let f[2:3] = [p[0] - 1, p[0] - 1]
            let parts += [copy(f)]
            let parts += [[p[0], p[1], len(a:string) - 1, len(a:string) - 1]]
          endif
        else
          " case like: 'abc_def_'
          let f[2:3] = [p[0] - 1, p[1] - 1]
          let parts += [copy(f)]
        endif
      else
        if parts == []
          " case like: '_abc_def...'
          let f[2:3] = [p[0] - 1, p[1] - 1]
          let parts += [copy(f)]
        else
          " case like: 'abc_def_ghi...'
          let f[2:3] = [p[0] - 1, p[0] - 1]
          let parts += [copy(f)]
        endif

        let f[0:1] = [p[0], p[1]]
      endif
    elseif i == n
      " last delimiter
      if p[1] != len(a:string)
        " case like: '..._xyz'
        let f[2:3] = [p[0] - 1, p[0] - 1]
        let parts += [copy(f)]
        let parts += [[p[0], p[1], len(a:string) - 1, len(a:string) - 1]]
      else
        " case like: '..._xyz_'
        let f[2:3] = [p[0] - 1, p[1] - 1]
        let parts += [copy(f)]
      endif
    else
      " intermediate part like: '..._mno...'
      let f[2:3] = [p[0] - 1, p[0] - 1]
      let parts += [copy(f)]
      let f[0:1] = [p[0], p[1]]
    endif
  endfor

"   for part in parts
"     PP! [a:string[part[1] : part[2]], a:string[part[0] : part[3]], part]
"   endfor

  return parts
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
