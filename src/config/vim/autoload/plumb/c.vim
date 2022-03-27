if exists('g:loaded_plumb_c') | finish | endif
let g:loaded_plumb_c = 1

function! plumb#c#parents()
    return ['doxygen']
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

function! plumb#c#for(type, name, ...)
    let indent = s:Indent(indent('.'))
    let name = a:name
    let begin = '0'
    let end = 'n'
    if len(a:000) >= 1
        let begin = a:000[0]
    endif
    if len(a:000) >= 2
        let end = a:000[1]
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%sfor (%s %s=%s; %s<%s; ++%s) {', indent, a:type, name, begin, name, end, name),
                \ printf('%s    ', indent),
                \ printf('%s}', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#c#inc(...)
    let indent = s:Indent(indent('.'))
    if len(a:000) >= 1
        let name = escape(join(a:000,' '), '"')
        call s:ReplaceLine(line('.'), [
                    \ printf('%s#include <%s>', indent, name),
                    \ printf('%s', indent)])
    else
        let name = expand('%:r')
        let header_extensions = ['', '.hh', '.hpp', '.H', '.h']
        for ext in header_extensions
            if filereadable(name . ext)
                let name = name . ext
                break
            endif
        endfor
        let short_name = substitute(name, '^src/', '', 'g')
        call s:ReplaceLine(line('.'), [
                    \ printf('%s#include <%s>', indent, short_name)], 0)
    endif
    call cursor(line('.'), strchars(getline(line('.')))-1)
endfunction

function! plumb#c#main(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%sint main(int argc, char* argv[]) {', indent),
                \ printf('%s%s', indent, repeat(' ', &shiftwidth)),
                \ printf('%s%sreturn 0;', indent, repeat(' ', &shiftwidth)),
                \ printf('%s}', indent)], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#c#h(...)
    let name = HeaderguardName()
    call s:ReplaceLine(line('.'), [
                \ printf('#ifndef %s', name),
                \ printf('#define %s', name),
                \ '',
                \ '',
                \ '',
                \ printf('#endif // vim:filetype=%s', &filetype)], 0)
    call cursor(line('.')+3, 999)
endfunction

function! plumb#c#print(name, ...)
    let name = HeaderguardName()
    let indent = s:Indent(indent('.'))
    let name1 = escape(a:name, '"')
    let name2 = a:name
    if len(a:000) >= 1
        let name2 = a:000[0]
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%sfprintf(stderr, "%s=%%d\n", %s)', indent, name1, name2),
                \ printf('%s', indent)])
endfunction

