" READ ME!!!!
"
" Slightly modified version of the indent file found at:
" https://github.com/LnL7/vim-nix/blob/master/indent/nix.vim
" I added better support for brackets on newlines, and working logic for
" multiline strings.
"
" It isn't perfect - there's one issue I don't know how to fix, where multiline
" functions don't get an extra level of indentation after line one, because of
" no more equals sign logic. I'm not sure I can fix that without causing larger
" regressions elsewhere, though.
"
" I also have a strange case where `in\n{` expressions get indented slightly
" wrong - but that one, I hope I can fix.
"
" If you have any improvements, feel free to let me know! I'm hoping to PR these
" changes back when I get the time.

" If you want to see the parts I changed from the original, look for `CHANGED`
" in this file, and you'll find them.

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetNixIndent()
setlocal indentkeys+=0=then,0=else,0=inherit,0=in,*<Return>

if exists("*GetNixIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:skip_syntax = '\%(Comment\|String\)$'
let s:binding_open = '\%(\<let\>\)'
let s:binding_close = '\%(\<in\>\)'

" CHANGED: Added parentheses to the block characters. Note that multiline
" strings with '' aren't here: I added special logic for them too, though.
let s:block_open  = '\%({\|[\|(\)'
let s:block_close = '\%(}\|]\|)\)'

function! GetNixIndent()
  let lnum = prevnonblank(v:lnum - 1)
  let ind  = indent(lnum)

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

  " Skip indentation for single line comments explicitly, in case a
  " comment was just inserted (eg. visual block mode)
  if getline(v:lnum) =~ '^\s*#'
    return indent(v:lnum)
  endif

  if synIDattr(synID(v:lnum, 1, 1), "name") !~ s:skip_syntax
    let current_line = getline(v:lnum)
    let last_line = getline(lnum)

    if current_line =~ '^\s*in\>'
      let save_cursor = getcurpos()
      normal ^
      let bslnum = searchpair(s:binding_open, '', s:binding_close, 'bnW',
            \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "StringSpecial$"')
      call setpos('.', save_cursor)
      return indent(bslnum)
    endif

    if last_line =~ s:block_open . '\s*$'
      let ind += &sw
    endif

    if current_line =~ '^\s*' . s:block_close
      let ind -= &sw
    endif

    " CHANGED: Removed the case where an equals sign at the end of a line
    " increased indentation. This messes up some other stuff, like when you have
    " a function that extends to multiple lines, but it causes way less issues
    " in general.

    if last_line =~ '\<let\s*$'
      let ind += &sw
    endif

    if last_line =~ '^\<in\s*$'
      let ind += &sw
    endif

    if current_line =~ '^\s*in\>'
      let ind -= &sw
    endif

    " CHANGED: added the two cases below, to properly add indentation when in a
    " multiline quote. Maybe that's what the fancy `^nixString` logic is supposed
    " to do, but it doesn't work, and this does!
    if last_line =~ "\s*''$"
      let ind += &sw
    endif

    " CHANGED: This isn't foolproof since it relies on you being inside an
    " attrset, which technically isn't required to use these. But I think it'll
    " be fine in practice.
    if current_line =~ "\s*'';$"
      let ind -= &sw
    endif
  endif

  if synIDattr(synID(v:lnum, 1, 1), "name") =~ '^nixString'
    let current_line = getline(v:lnum)

    let ind = indent(v:lnum)
    let bslnum = searchpair('''''', '', '''''', 'bnW',
          \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "StringSpecial$"')

    if ind <= indent(bslnum)
      let ind = indent(bslnum) + &sw
    endif

    if current_line =~ '^\s*''''[^''\$]'
      let ind = indent(bslnum)
    endif
    if current_line =~ '^\s*''''$'
      let ind = indent(bslnum)
    endif
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
