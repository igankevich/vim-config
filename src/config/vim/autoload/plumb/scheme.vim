if exists('g:loaded_plumb_scheme') | finish | endif
let g:loaded_plumb_scheme = 1

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

function! s:ReplaceRange(replacement)
    let line_no = line('.')
    let line = getline(line_no)
    let a = line[0:g:plumb_start_col-1]
    let a = a . a:replacement
    let pos = strlen(a)
    let a = a . line[g:plumb_end_col+1:]
    call setline(line_no, a)
    call cursor(line_no, pos)
endfunction

function! plumb#scheme#nbsp(...)
    call s:ReplaceRange("\u00A0 1234")
endfunction

function! plumb#scheme#module(...)
    let name = join(split(expand('%:r'),'/'),' ')
    call s:ReplaceLine(line('.'), [printf('(define-module (%s))', name)], 0)
    normal $h
endfunction

function! plumb#scheme#format(name, ...)
    let indent = s:Indent(indent('.'))
    let name1 = escape(a:name, '"')
    let name2 = a:name
    if len(a:000) >= 1
        let name2 = a:000[0]
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%s(format (current-error-port) "%s=~a\n" %s)', indent, name1, name2),
                \ printf('%s', indent)])
endfunction

function! plumb#scheme#contact(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf("%s(make <contact>", indent),
                \ printf("%s      #:name '()", indent),
                \ printf("%s      #:phone '()", indent),
                \ printf("%s      #:email '()", indent),
                \ printf("%s      #:organisation '()", indent),
                \ printf("%s      #:id \"%s\")", indent, systemlist('uuidgen')[0])], 0)
    normal j0f(l
endfunction

function! plumb#scheme#date(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'),
                \ [printf('%s(date "%s")', indent, strftime('%Y-%m-%dT%H:%M:%S%z'))], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#scheme#uuid(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'),
                \ [printf('%s"%s"', indent, trim(system('uuidgen')))], 0)
    call cursor(line('.')+1, 999)
endfunction

function! plumb#scheme#source(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'),
                \ [
                \ printf('%s(source', indent),
                \ printf('%s%s(origin', indent, shift),
                \ printf('%s%s%s(method git-fetch)', indent, shift, shift),
                \ printf('%s%s%s(uri', indent, shift, shift),
                \ printf('%s%s%s%s(git-reference', indent, shift, shift, shift),
                \ printf('%s%s%s%s%s(url "%s")',
                \ indent, shift, shift, shift, shift, join(a:000, ' ')),
                \ printf('%s%s%s%s%s(commit version)))', indent, shift, shift, shift, shift),
                \ printf('%s%s%s(file-name (git-file-name name version))',
                \ indent, shift, shift),
                \ printf('%s%s%s(sha256 (base32 ""))))', indent, shift, shift)], 0)
    normal 8j0f"l
endfunction

function! plumb#scheme#gnu(...)
    let indent = s:Indent(indent('.'))
    let name = join(a:000, ' ')
    call s:ReplaceLine(line('.'),
                \ [printf('%s(@ (gnu packages %s) %s)', indent, name, name)], 0)
    call cursor(line('.')+1, 999)
endfunction

