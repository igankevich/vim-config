if exists('g:loaded_plumb_sh') | finish | endif
let g:loaded_plumb_sh = 1

function! plumb#sh#names()
    return {
                \ '#': 'shebang'
                \ }
endfunction

function! s:Indent(n)
    return repeat(' ', a:n)
endfunction

function! s:ReplaceLine(line, lines, ...)
    call setline(a:line, a:lines[0])
    call append(a:line, a:lines[1:])
    if len(a:000) == 0
        call cursor(a:line+len(a:lines), indent(a:line))
    endif
endfunction

function! plumb#sh#shebang()
    call s:ReplaceLine(line('.'), [printf('#!/bin/sh'), ''])
endfunction


