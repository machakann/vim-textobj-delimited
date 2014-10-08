" textobj-delimited
" text-object for treating a delimited part of a word by {count}
" The words like, foo_bar_baz, foo#bar#baz, FooBarBaz, are expected targets.

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
      \ ['\m/', '\m\%(/[-.[:alnum:]_~]\+\)\+', 10],
      \ ['\m\\', '\m\a:\%(\\[^\\/?:*"<>|]\+\)\+\ze\%(''[^a-z]\|$\)', 10],
      \ ['\m[#_-]', '\m\<\%([#_-]\k\+\|\k\+[#_-]\)\%(\k*[#_-]\?\)*\>'],
      \ ['\m\C\ze[A-Z]', '\m\C\<[A-Z]\?\k\+[A-Z]\%(\k*[A-Z]\?\)*\>'],
      \ ]

function! textobj#delimited#i(mode)
  return s:prototype('i', a:mode)
endfunction

function! textobj#delimited#a(mode)
  return s:prototype('a', a:mode)
endfunction

function! textobj#delimited#I(mode)
  return s:prototype('I', a:mode)
endfunction

function! textobj#delimited#A(mode)
  return s:prototype('A', a:mode)
endfunction

function! s:prototype(kind, mode) "{{{
  let l:count  = v:count1
  let orig_pos = [line('.'), col('.')]
  let string   = getline(orig_pos[0])
  let mode     = (a:mode ==# 'o') ? 'o' : visualmode()

  " user configuration
  let patterns = s:user_conf('patterns', s:textobj_delimited_patterns)

  let candidates = []
  " search for the head and tail of a delimited word
  for pattern in patterns
    let delimiter = pattern[0]
    let delimited = pattern[1]
    let priority  = get(pattern, 2, 0)

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

      let candidates += [[delimiter, body, head[1], tail[1], priority]]
      break
    endwhile

    call cursor(orig_pos)
  endfor

  " if any candidate could not be found, then quit immediately.
  if candidates == []
    if a:mode == 'v'
      normal! gv
    endif

    return
  endif

  " check whether the cursor is on a delimited word.
  let filtered = filter(copy(candidates),
        \          '(v:val[2] <= orig_pos[1]) && (v:val[3] >= orig_pos[1])')

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
    " if the cursor is on the word, then choose the candidate which has
    " highest priority and the shortest length.
    let target = sort(filtered, 's:compare_priority')[0]
  endif

  if (filtered != []) && (v:count == 0)
    let [start_pos, end_pos] = s:search_destination(a:kind, orig_pos, mode,
          \                                               l:count, target, 1)
  else
    let [start_pos, end_pos] = s:search_destination(a:kind, orig_pos, mode,
          \                                               l:count, target, 0)
  endif

  " select textobject
  call cursor(start_pos)

  if mode == "\<C-v>"
    execute "normal! \<C-v>"
  else
    normal! v
  endif

  call cursor(end_pos)

  " counter measure for the 'selection' option being 'exclusive'
  if &selection == 'exclusive'
    normal! l
  endif

  return
endfunction
"}}}
function! s:user_conf(name, default)    "{{{
  let user_conf = a:default

  if exists('g:textobj_delimited_' . a:name)
    let user_conf = g:textobj_delimited_{a:name}
  endif

  if exists('t:textobj_delimited_' . a:name)
    let user_conf = t:textobj_delimited_{a:name}
  endif

  if exists('w:textobj_delimited_' . a:name)
    let user_conf = w:textobj_delimited_{a:name}
  endif

  if exists('b:textobj_delimited_' . a:name)
    let user_conf = b:textobj_delimited_{a:name}
  endif

  return user_conf
endfunction
"}}}
function! s:search_destination(kind, orig_pos, mode, count, target, get_the_part_under_the_cursor) "{{{
  let split_parts = s:parse(a:target[1], a:target[0])

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

    if (start == -1) && (end == -1)
      " cursor is on the ended delimiter
      "    # here
      " abc_

      if a:kind ==? 'i'
        let start = part[1]
        let end   = part[2]
      elseif a:kind ==? 'a'
        let start = part[0]
        let end   = part[3]
      endif
    endif
  else
    let idx   = (len(split_parts) < a:count)
          \   ? (len(split_parts) - 1)
          \   : (a:count - 1)

    if a:kind ==? 'i'
      let start = split_parts[idx][1]
      let end   = split_parts[idx][2]
    elseif a:kind ==? 'a'
      let start = split_parts[idx][0]
      let end   = split_parts[idx][3]
    endif
  endif

  " increment selection area
  if (a:mode ==# 'v' || a:mode ==# "\<C-v>")
    \ && (a:orig_pos[0] == line("'<"))
    \ && (a:orig_pos[0] == line("'>"))

    let i = 0
    let _start         = start
    let _end           = end
    let select_start   = col("'<")
    let select_end     = col("'>")
    let is_match_start = 0
    let is_match_end   = 0
    let is_rev_order   = 0

    " counter measure for the 'selection' option being 'exclusive'
    if &selection == 'exclusive'
      let select_end -= 1
    endif

    for _ in split_parts
      if !is_match_start
        " NOTE: It should be checked _[1] first to update is_rev_order!
        "       Because sometimes _[0] == _[1] is possible.
        if a:target[2] + _[1] == select_start
          let is_match_start = 1

          if a:kind =~# '[AI]'
            let idx = i
          elseif a:kind ==# 'a'
            let _start = _[1]
            let is_rev_order = 1
          elseif a:kind ==# 'i'
            let _start = _[1]
          endif
        elseif a:target[2] + _[0] == select_start
          let is_match_start = 1

          if a:kind =~# '[AI]'
            let idx = i
          elseif a:kind =~# '[ai]'
            let _start = _[0]
          endif
        endif
      end

      if !is_match_end && is_match_start
        " NOTE: It should be checked _[4] first to update is_rev_order!
        if (a:target[2] + _[4] == select_end) && (_[4] != 0)
          let is_match_end = 1

          if a:kind =~# '[ai]'
            let idx = i
          elseif a:kind ==# 'A'
            let _end = _[4]
            let is_rev_order = 1
          elseif a:kind ==# 'I'
            let _end = _[4]
          endif
        elseif a:target[2] + _[2] == select_end
          let is_match_end = 1

          if a:kind =~# '[ai]'
            let idx = i
          elseif a:kind =~# '[AI]'
            let _end = _[2]
          endif
        elseif a:target[2] + _[3] == select_end
          let is_match_end = 1

          if a:kind =~# '[ai]'
            let idx = i
          elseif a:kind =~# '[AI]'
            let _end = _[3]
          endif
        endif
      end

      if is_match_start && is_match_end
        let start = _start
        let end   = _end

        if a:kind ==# 'i'
          let n_max = len(split_parts) - idx - 1
          let n     = (n_max < a:count) ? n_max : a:count
          let end   = split_parts[idx + n][2]
        elseif a:kind ==# 'a'
          let n_max = len(split_parts) - idx - 1
          let n     = (n_max < a:count) ? n_max : a:count
          let m     = is_rev_order && (split_parts[idx + n][4] != 0) ? 4 : 3
          let end   = split_parts[idx + n][m]
        elseif a:kind ==# 'I'
          let n_max = idx
          let n     = (n_max < a:count) ? n_max : a:count
          let start = split_parts[idx - n][1]
        elseif a:kind ==# 'A'
          let n_max = idx
          let n     = (n_max < a:count) ? n_max : a:count
          let m     = is_rev_order ? 1 : 0
          let start = split_parts[idx - n][m]
        endif

        break
      endif

      let i += 1
    endfor
  endif

  let start_pos = [a:orig_pos[0], a:target[2] + start]
  let end_pos   = [a:orig_pos[0], a:target[2] +  end ]

  return [start_pos, end_pos]
endfunction
"}}}
function! s:parse(string, delimiter)  "{{{
  let head = -1
  let tail =  0

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
  "           head_delimiter_start (head of a textobject),
  "           delimited_word_start (head of inner textobject),
  "           delimited_word_end (tail of inner textobject),
  "           delimited_word_end or tail_delimiter_end (tail of a textobject),
  "           tail_delimiter_end
  "         ]

  let i = 0
  let n = len(pos)
  let l = len(a:string)
  let f = [0, 0, 0, 0, 0]
  for p in pos
    let i += 1

    if i == 1
      " first delimiter
      if n == 1
        " also the last
        if p[1] != l
          if p[0] != 0
            " case like: 'abc_def'
            let parts += [[0, 0, p[0] - 1, p[1] - 1, p[1] - 1]]
            let parts += [[p[0], p[1], l - 1, l - 1, 0]]
          else
            " case like: '_abc'
            let parts += [[0, p[1], l - 1, l - 1, 0]]
          endif
        else
          " case like: 'abc_'
          let parts += [[0, 0, p[0] - 1, p[1] - 1, p[1] - 1]]
        endif
      else
        if p[0] != 0
          " case like: 'abc_...'
          let parts += [[0, 0, p[0] - 1, p[1] - 1, p[1] - 1]]
          let f[0:1] = [p[0], p[1]]
        else
          " case like: '_abc_...'
          let f[0:1] = [0, p[1]]
        endif
      endif
    elseif i == n
      " last delimiter
      if p[1] != l
        " case like: '..._xyz'
        let f[2:4] = [p[0] - 1, p[0] - 1, p[1] - 1]
        let parts += [copy(f)]
        let parts += [[p[0], p[1], l - 1, l - 1, 0]]
      else
        " case like: '..._xyz_'
        let f[2:4] = [p[0] - 1, p[0] - 1, p[1] - 1]
        let parts += [copy(f)]
      endif
    else
      " intermediate part like: '..._mno...'
      let f[2:4] = [p[0] - 1, p[0] - 1, p[1] - 1]
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
function! s:compare_priority(i1, i2) "{{{
  if a:i1[4] > a:i2[4]
    return -1
  elseif a:i1[4] < a:i2[4]
    return 1
  else
    let length1 = a:i1[3] - a:i1[2]
    let length2 = a:i2[3] - a:i2[2]
    if length1 < length2
      return -1
    elseif length1 > length2
      return 1
    endif
  endif
  return 0
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
