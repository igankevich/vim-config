if exists('g:loaded_plumb_meson') | finish | endif
let g:loaded_plumb_meson = 1

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

function! plumb#meson#project(...)
    if len(a:000) == 0
        let name = expand('%:h:t')
    else
        let name = join(a:000, ' ')
    endif
    call s:ReplaceLine(line('.'), [
                \ printf("project('%s',", name),
                \ printf("        'cpp',"),
                \ printf("        version: '0.1.0',"),
                \ printf("        meson_version: '>=0.50.0',"),
                \ printf("        default_options: ['cpp_std=c++17'])"),
                \ ''])
endfunction
