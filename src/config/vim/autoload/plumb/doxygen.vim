if exists('g:loaded_plumb_doxygen') | finish | endif
let g:loaded_plumb_doxygen = 1

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

function! plumb#doxygen#doc(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s/**', indent),
                \ printf('%s\brief %s', indent, join(a:000,' ')),
                \ printf('%s*/', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#doxygen#copydoc(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s/**', indent),
                \ printf('%s\copydoc %s', indent, join(a:000,' ')),
                \ printf('%s*/', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#doxygen#date(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\date %s', indent, strftime('%Y-%m-%d')),
                \ printf('%s', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#doxygen#author(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\author %s', indent, systemlist('git config user.name')[0]),
                \ printf('%s', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#doxygen#todo(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [printf('%s// TODO %s', indent, join(a:000,' '))], 0)
    call cursor(line('.')+1, 999)
endfunction
