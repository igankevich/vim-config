if exists('g:loaded_plumb_cpp') | finish | endif
let g:loaded_plumb_cpp = 1

function! plumb#cpp#names()
    return {
                \ '==': 'eq',
                \ '==2': 'eq2',
                \ '<': 'lt',
                \ '<2': 'lt2',
                \ '<<': 'insert',
                \ '>>': 'extract',
                \ '#inc': 'inc'
                \ }
endfunction

function! plumb#cpp#parents()
    return ['c', 'doxygen']
endfunction

function! s:NormaliseName(name)
    return split(a:name,'[={;,]')[0]
endfunction

function! s:Indent(n)
    return repeat(' ', a:n)
endfunction

function! s:ReplaceLine(line, lines, ...)
    call setline(a:line, a:lines[0])
    call append(a:line, a:lines[1:])
endfunction

function! s:TypeExpand(type)
    let type = a:type
    let primitive = ['bool', 'char', 'short', 'int', 'long', 'long long',
                \ 'unsigned', 'unsigned char', 'unsigned short', 'unsigned int',
                \ 'unsigned long', 'unsigned long long', 'size_t', 'ptrdiff_t',
                \ 'int8_t', 'int16_t', 'int32_t', 'int64_t',
                \ 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t',
                \ 'std::size_t', 'std::ptrdiff_t', 'T',
                \ 'std::int8_t', 'std::int16_t', 'std::int32_t', 'std::int64_t',
                \ 'std::uint8_t', 'std::uint16_t', 'std::uint32_t', 'std::uint64_t']
    if index(primitive, a:type) != -1 || a:type =~# '\*$'
        let type = a:type
    else
        let type = 'const ' . a:type . '&'
    endif
    return type
endfunction

function! plumb#cpp#get(type, name, ...)
    let indent = s:Indent(indent('.'))
    let field_name = s:NormaliseName(a:name)
    let name = field_name
    if name =~# '^_' | let name = name[1:] | endif
    let type = s:TypeExpand(a:type)
    call s:ReplaceLine(line('.'), [
                \ indent . 'inline ' . type . ' ' . name . '() const noexcept {',
                \ indent . '    return this->' . field_name . ';',
                \ indent . '}',
                \ ''])
    normal jjj$
endfunction

function! plumb#cpp#set(type, name, ...)
    let indent = s:Indent(indent('.'))
    let field_name = s:NormaliseName(a:name)
    let name = field_name
    if name =~# '^_' | let name = name[1:] | endif
    let type = s:TypeExpand(a:type)
    call s:ReplaceLine(line('.'), [
                \ indent . 'inline void ' . name . '(' . type . ' rhs) noexcept {',
                \ indent . '    this->' . field_name . ' = rhs;',
                \ indent . '}',
                \ ''])
    normal jjj$
endfunction

function! plumb#cpp#eq(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%sinline bool operator==(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn %s;', indent, shift, join(a:000, ' ')),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator!=(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn !this->operator==(rhs);', indent, shift),
                \ printf('%s}', indent),
                \ ''])
    normal jjjjjjj$
endfunction

function! plumb#cpp#eq2(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%sinline bool operator==(const %s& lhs, const %s& rhs) noexcept {', indent, a:type, a:type),
                \ printf('%s%sreturn %s;', indent, shift, join(a:000, ' ')),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator!=(const %s& lhs, const %s& rhs) noexcept {', indent, a:type)
                \ printf('%s%sreturn !operator==(lhs, rhs);', indent, shift),
                \ printf('%s}', indent),
                \ ''])
    normal jjjjjjj$
endfunction

function! plumb#cpp#lt(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%sinline bool operator<(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn %s;', indent, shift, join(a:000, ' ')),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator<=(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn this->operator<(rhs) || this->operator==(rhs);', indent, shift),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator>(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn !this->operator<(rhs) && !this->operator==(rhs);', indent, shift),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator>=(const %s& rhs) const noexcept {', indent, a:type),
                \ printf('%s%sreturn !this->operator<(rhs);', indent, shift),
                \ printf('%s}', indent),
                \ ''])
    normal 15j$
endfunction

function! plumb#cpp#lt2(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    call s:ReplaceLine(line('.'), [
                \ printf('%sinline bool operator<(const %s& lhs, const %s& rhs) noexcept {', indent, a:type, a:type),
                \ printf('%s%sreturn %s;', indent, shift, join(a:000, ' ')),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator<=(const %s& lhs, const %s& rhs) noexcept {', indent, a:type, a:type),
                \ printf('%s%sreturn operator<(lhs,rhs) || operator==(lhs,rhs);', indent, shift),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator>(const %s& lhs, const %s& rhs) noexcept {', indent, a:type, a:type),
                \ printf('%s%sreturn !operator<(lhs,rhs) && !operator==(lhs,rhs);', indent, shift),
                \ printf('%s}', indent),
                \ '',
                \ printf('%sinline bool operator>=(const %s& lhs, const %s& rhs) noexcept {', indent, a:type, a:type),
                \ printf('%s%sreturn !operator<(lhs,rhs);', indent, shift),
                \ printf('%s}', indent),
                \ ''])
    normal 15j$
endfunction

function! plumb#cpp#insert(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    if len(a:000) >= 1
        let stream_type = a:000[0]
    else
        let stream_type = 'std::ostream'
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%s%s& operator<<(%s& out, const %s& rhs) {',
                \        indent, stream_type, stream_type, a:type),
                \ printf('%s%sreturn out;', indent, shift),
                \ printf('%s}', indent)])
    normal j$
endfunction

function! plumb#cpp#extract(type, ...)
    let indent = s:Indent(indent('.'))
    let shift = repeat(' ', &shiftwidth)
    if len(a:000) >= 1
        let stream_type = a:000[0]
    else
        let stream_type = 'std::istream'
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%s%s& operator>>(%s& in, %s& rhs) {',
                \        indent, stream_type, stream_type, a:type),
                \ printf('%s%sreturn in;', indent, shift),
                \ printf('%s}', indent)])
    normal j$
endfunction

function! plumb#cpp#default(type, ...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%s%s() = default;', indent, a:type),
                \ printf('%s~%s() = default;', indent, a:type),
                \ printf('%s%s(const %s&) = default;', indent, a:type, a:type),
                \ printf('%s%s& operator=(const %s&) = default;', indent, a:type, a:type),
                \ printf('%s%s(%s&&) = default;', indent, a:type, a:type),
                \ printf('%s%s& operator=(%s&&) = default;', indent, a:type, a:type),
                \ ''])
    normal 6j$
endfunction

function! plumb#cpp#foreach(name1, name2, ...)
    let indent = s:Indent(indent('.'))
    let name1 = s:NormaliseName(a:name1)
    let name2 = s:NormaliseName(a:name2)
    call s:ReplaceLine(line('.'), [
                \ printf('%sfor (const auto& %s : %s) {', indent, name1, name2),
                \ printf('%s    ', indent),
                \ printf('%s}', indent)])
    normal j$
endfunction

function! plumb#cpp#clog(name, ...)
    let indent = s:Indent(indent('.'))
    let name1 = escape(a:name, '"')
    let name2 = a:name
    if len(a:000) >= 1
        let name2 = a:000[0]
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%sstd::clog << "%s=" << %s << std::endl;', indent, name1, name2)])
    normal $
endfunction

function! plumb#cpp#ns(...)
    let indent = s:Indent(indent('.'))
    if len(a:000) == 0
        let name = ' '
    else
        let name = s:NormaliseName(join(a:000, ' ')) . ' '
    endif
    call s:ReplaceLine(line('.'), [
                \ printf('%snamespace %s{', indent, name),
                \ printf('%s    ', indent),
                \ printf('%s}', indent)])
    normal j$
endfunction

function! plumb#cpp#t(...)
    let indent = s:Indent(indent('.'))
    let types = map(copy(a:000), '"class " . v:val')
    if len(types) == 0
        call s:ReplaceLine(line('.'), [printf('%stemplate <>', indent)])
        call cursor(line('.'), indent(line('.'))+10)
    else
        call s:ReplaceLine(line('.'), [
                    \ printf('%stemplate <%s>', indent, join(types, ', ')),
                    \ printf('%s', indent)])
        normal j$
    endif
endfunction

function! plumb#cpp#test(...)
    call s:ReplaceLine(line('.'), [
                \ '#include <algorithm>',
                \ '#include <chrono>',
                \ '#include <cmath>',
                \ '#include <fstream>',
                \ '#include <iomanip>',
                \ '#include <iostream>',
                \ '#include <limits>',
                \ '#include <string>',
                \ '#include <thread>',
                \ '#include <vector>',
                \ '',
                \ 'int main(int argc, char* argv[]) {',
                \ '    ',
                \ '    return 0;',
                \ '}'])
    normal 11j$
endfunction

function! plumb#cpp#R(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [printf('%sR"(%s)"', indent, join(a:000,' '))])
    normal $hh
endfunction

function! plumb#cpp#swap(name)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%sswap(this->%s, rhs.%s)', indent, a:name, a:name),
                \ ''])
    normal j$
endfunction

function! plumb#cpp#try(...)
    let indent = s:Indent(indent('.'))
    call s:ReplaceLine(line('.'), [
                \ printf('%stry {', indent),
                \ printf('%s%s%s', indent, repeat(' ', &shiftwidth), join(a:000,' ')),
                \ printf('%s} catch (const std::exception& err) {', indent),
                \ printf('%s}', indent)])
    normal j$
endfunction

" convert typedef to using
function! plumb#cpp#typedef(...)
    normal 0^dwf;Bdt;^iusing " = f;hxj
endfunction
