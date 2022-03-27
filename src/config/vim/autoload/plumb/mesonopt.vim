if exists('g:loaded_plumb_mesonopt') | finish | endif
let g:loaded_plumb_mesonopt = 1

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

function! plumb#mesonopt#option(...)
    call s:ReplaceLine(line('.'), [
                \ printf("option('%s',", join(a:000,' ')),
                \ printf("       type: 'boolean',"),
                \ printf("       value: true,"),
                \ printf("       description: '')"),
                \ ''], 0)
    normal $F'h
endfunction

