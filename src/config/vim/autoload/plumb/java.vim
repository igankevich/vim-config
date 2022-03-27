if exists('g:loaded_plumb_java') | finish | endif
let g:loaded_plumb_java = 1

function! s:NormaliseName(name)
    return split(a:name,'[={;,]')[0]
endfunction

function! s:Indent(n)
    return repeat(' ', a:n)
endfunction

function! s:ReplaceLine(line, lines, ...)
    call setline(a:line, a:lines[0])
    call append(a:line, a:lines[1:])
endfunction

function! plumb#java#get(access, type, name, ...)
    let indent = s:Indent(indent('.'))
    let field_name = s:NormaliseName(a:name)
    let name = field_name
    if name =~# '^_' | let name = name[1:] | endif
    let name = 'get' . toupper(name[:0]) . name[1:]
    let type = a:type
    call s:ReplaceLine(line('.'), [
                \ indent . 'public ' . type . ' ' . name . '() {',
                \ indent . indent . 'return this.' . field_name . ';',
                \ indent . '}',
                \ ''])
    normal jjj$
endfunction

function! plumb#java#set(access, type, name, ...)
    let indent = s:Indent(indent('.'))
    let field_name = s:NormaliseName(a:name)
    let name = field_name
    if name =~# '^_' | let name = name[1:] | endif
    let name = 'set' . toupper(name[:0]) . name[1:]
    let type = a:type
    call s:ReplaceLine(line('.'), [
                \ indent . 'public void ' . name . '(' . type . ' ' . field_name . ') {',
                \ indent . indent . 'this.' . field_name . ' = ' . field_name . ';',
                \ indent . '}',
                \ ''])
    normal jjj$
endfunction

function! plumb#java#toString(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ indent . '@Override',
                \ indent . 'public String toString() {',
                \ indent . indent . 'return ;',
                \ indent . '}',
                \ ''])
    normal jj$
endfunction

function! plumb#java#equals(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ indent . '@Override',
                \ indent . 'public boolean equals(Object other) {',
                \ indent . indent . 'if (other == null) { return false; }',
                \ indent . indent . 'if (other.getClass() == getClass()) { return false; }',
                \ indent . indent . 'return ;',
                \ indent . '}',
                \ ''])
    normal jjjj$
endfunction

function! plumb#java#hashCode(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ indent . '@Override',
                \ indent . 'public int hashCode() {',
                \ indent . indent . 'return ;',
                \ indent . '}',
                \ ''])
    normal jj$
endfunction
