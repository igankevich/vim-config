if exists('g:loaded_plumb_gitcommit') | finish | endif
let g:loaded_plumb_gitcommit = 1

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

function! plumb#gitcommit#new(...)
    let file = a:000[0]
    let variable = a:000[1]
    call s:ReplaceLine(line('.'), [
                \ printf('gnu: Add %s.', variable),
                \ printf(''),
                \ printf('* %s (%s): New variable.', file, variable)], 0)
    normal $h
endfunction
