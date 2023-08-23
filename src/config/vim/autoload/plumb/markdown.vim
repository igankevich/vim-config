if exists('g:loaded_plumb_markdown') | finish | endif
let g:loaded_plumb_markdown = 1

function! plumb#markdown#names()
    return {
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

function! plumb#markdown#href(url)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s[](%s)', indent, a:url)], 0)
    normal ^f[l
endfunction

function! plumb#markdown#date(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s%s', indent, strftime('%Y-%m-%d'))], 0)
    normal ^f[l
endfunction
