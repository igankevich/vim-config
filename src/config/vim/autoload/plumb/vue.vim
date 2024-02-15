if exists('g:loaded_plumb_vue') | finish | endif
let g:loaded_plumb_vue = 1

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

function! plumb#vue#define()
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    let path = expand('%')
    let path = substitute(path, '^pages/', '/', '')
    let path = substitute(path, '/index\.vue$', '', '')
    let path = substitute(path, '\.vue$', '.', '')
    let filename = fnamemodify(path, ':t')
    call s:ReplaceLine(line('.'),
                \ [
                \ printf('definePageMeta({'),
                \ printf('%s%spath: "%s",', indent, shift, path),
                \ printf('%s%salias: ["/%s"],', indent, shift, filename),
                \ printf('})')
                \ ], 0)
endfunction
