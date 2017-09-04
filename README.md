textobj-delimited
=================

[![Build Status](https://travis-ci.org/machakann/vim-textobj-delimited.svg?branch=master)](https://travis-ci.org/machakann/vim-textobj-delimited)
[![Build status](https://ci.appveyor.com/api/projects/status/m7jd78ldnpshctno/branch/master?svg=true)](https://ci.appveyor.com/project/machakann/vim-textobj-delimited/branch/master)

The textobject plugin to do well with each delimited parts of string.

# Brief explanation
This textobject provides the keymappings to select a part of a delimited string. `id`, `ad`, `iD`, `aD` is used in default. Please see following examples and doc/textobj-delimited.txt.

# Examples
```
------------------------------------------------
 key input: did
  #                    #         : cursor
 'foo_bar_baz'   ->   '_bar_baz'
------------------------------------------------
 key input: did
      #                    #     : cursor
 'foo_bar_baz'   ->   'foo__baz'
------------------------------------------------
 key input: did
          #                   #  : cursor
 'foo_bar_baz'   ->   'foo_bar_'
------------------------------------------------
 key input: d1id
      #                #         : cursor
 'foo_bar_baz'   ->   '_bar_baz'
------------------------------------------------
 key input: d2id
  #                        #     : cursor
 'foo_bar_baz'   ->   'foo__baz'
------------------------------------------------
 key input: d3id
  #                           #  : cursor
 'foo_bar_baz'   ->   'foo_bar_'
------------------------------------------------
 key input: dad
  #                    #         : cursor
 'foo_bar_baz'   ->   'bar_baz'
------------------------------------------------
 key input: dad
      #                    #     : cursor
 'foo_bar_baz'   ->   'foo_baz'
------------------------------------------------
 key input: dad
          #                  #   : cursor
 'foo_bar_baz'   ->   'foo_bar'
------------------------------------------------
 key input: d1ad
      #                #         : cursor
 'foo_bar_baz'   ->   'bar_baz'
------------------------------------------------
 key input: d2ad
  #                        #     : cursor
 'foo_bar_baz'   ->   'foo_baz'
------------------------------------------------
 key input: d3ad
  #                          #   : cursor
 'foo_bar_baz'   ->   'foo_bar'
------------------------------------------------
```

---

When delimited parts are being selected in visual mode, this textobject behave differently from usual, expanding selection area like viwiwiw...
Assume the situation as following:

```
       |<-->|        : selected area
abcdef_ghijkl_mnopqr
```


If you use `id`, then you will get:

```
       |<--------->| : selected area
abcdef_ghijkl_mnopqr
```


If you use `iD`, then you will get:

```
|<--------->|        : selected area
abcdef_ghijkl_mnopqr
```

---

At the beginning of a word, `ad` and `aD` work tricky. Look the following examples.

If you use `dad`, the cut strings are different for '\_abc\_def\_ghi\_' and 'abc\_def\_ghi'.
```
         #                     #        : cursor
        _abc_def_ghi_    ->    _def_ghi_         (cut '_abc')

        #                      #        : cursor
        abc_def_ghi      ->    def_ghi           (cut 'abc_')
```
Thus, if a word has ended delimiters like '\_abc\_def\_ghi\_', ended delimiters would be preserved. If a word has no ended delimiters like 'abc\_def\_ghi', ended delimiters would not appear. `dad` keeps the exsistence/nonexistence of ended delimiters.

