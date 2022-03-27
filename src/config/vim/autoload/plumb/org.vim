if exists('g:loaded_plumb_org') | finish | endif
let g:loaded_plumb_org = 1

function! plumb#org#names()
    return {
                \ '\begin': 'begin_latex',
                \ 'url': 'href'
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

function! plumb#org#begin(name, ...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s#+begin_%s', indent, a:name),
                \ printf('%s', indent),
                \ printf('%s#+end_%s', indent, a:name)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#org#begin_latex(name, ...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{%s}', indent, a:name),
                \ printf('%s', indent),
                \ printf('%s\end{%s}', indent, a:name)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#org#prop()
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s:properties:', indent),
                \ printf('%s', indent),
                \ printf('%s:end:', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#org#href(url)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s[[%s][]]', indent, a:url)], 0)
    normal $F[l
endfunction
