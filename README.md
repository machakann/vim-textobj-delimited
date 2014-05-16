textobj-delimited
=================

The textobject plugin to do well with each delimited parts of string.

# Brief explanation
This textobject provides the keymappings to select a part of a delimited string. `id`, `ad`, `Id`, `Ad` is used in default. Please refer following examples and doc/textobj-delimited.txt.

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
