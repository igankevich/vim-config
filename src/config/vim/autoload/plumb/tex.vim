if exists('g:loaded_plumb_tex') | finish | endif
let g:loaded_plumb_tex = 1

function! plumb#tex#names()
    return {
                \ '\begin': 'begin',
                \ 'url': 'href',
                \ '(': 'brace_1',
                \ '[': 'brace_2',
                \ '{': 'brace_3',
                \ '|': 'brace_4'
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

function! plumb#tex#begin(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{%s}', indent, join(a:000, ' ')),
                \ printf('%s', indent),
                \ printf('%s\end{%s}', indent, join(a:000, ' '))], 0)
    normal j$
endfunction

function! plumb#tex#columns(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{columns}', indent),
                \ printf('%s%s\begin{column}{0.45\textwidth}', indent, indent),
                \ printf('%s%s%s%s', indent, indent, indent, join(a:000, ' ')),
                \ printf('%s%s\end{column}', indent, indent),
                \ printf('%s%s\begin{column}{0.45\textwidth}', indent, indent),
                \ printf('%s%s\end{column}', indent, indent),
                \ printf('%s\end{columns}', indent)], 0)
    normal j$
endfunction

function! plumb#tex#itemize(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{itemize}', indent),
                \ printf('%s\item %s', indent, join(a:000,' ')),
                \ printf('%s\end{itemize}', indent)], 0)
    normal j$
endfunction

function! plumb#tex#enumerate(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{enumerate}', indent),
                \ printf('%s\item %s', indent, join(a:000,' ')),
                \ printf('%s\end{enumerate}', indent)], 0)
    normal j$
endfunction

function! plumb#tex#href(url)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s\href{%s}{}', indent, a:url)], 0)
    normal $
endfunction

function! plumb#tex#table(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{table}', indent),
                \ printf('%s%s\centering', indent, shift),
                \ printf('%s%s\begin{tabular}{ll}', indent, shift),
                \ printf('%s%s\toprule', indent, shift),
                \ printf('%s%s%s', indent, shift, join(a:000,' ')),
                \ printf('%s%s\midrule', indent, shift),
                \ printf('%s%s\bottomrule', indent, shift),
                \ printf('%s%s\end{tabular}{ll}', indent, shift),
                \ printf('%s\end{table}', indent),
                \ ''], 0)
    normal jjjj$
endfunction

function! plumb#tex#figure(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%s\begin{figure}', indent),
                \ printf('%s%s\centering', indent, shift),
                \ printf('%s%s%s', indent, shift, join(a:000,' ')),
                \ printf('%s%s\caption{\label{}}', indent, shift),
                \ printf('%s\end{figure}', indent),
                \ ''], 0)
    normal jj$
endfunction

function! plumb#tex#brace_1(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [printf('%s\left(%s\right)', indent, join(a:000,' '))], 0)
    normal $F\
endfunction

function! plumb#tex#brace_2(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [printf('%s\left[%s\right]', indent, join(a:000,' '))], 0)
    normal $F\
endfunction

function! plumb#tex#brace_3(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [printf('%s\left\{%s\right\}', indent, join(a:000,' '))], 0)
    normal $F\
endfunction

function! plumb#tex#brace_3(...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [printf('%s\left|%s\right|', indent, join(a:000,' '))], 0)
    normal $F\
endfunction
