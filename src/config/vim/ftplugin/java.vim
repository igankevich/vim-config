setlocal shiftwidth=4 tabstop=4 expandtab
setlocal formatprg=java\ -jar\ ~/.local/share/google-java-format-1.4-all-deps.jar\ -a\ -

nnoremap <leader><enter> "jyiw:JavaImport j<c-z>
nnoremap <silent> <leader>p :call JavaPackage()<cr>
nnoremap <silent> <leader>s :call JavaSortImports()<cr>
nnoremap <silent> <leader>r :call JavaRenameFile()<cr>
nnoremap <silent> + :silent call JavaFormatParagraph()<cr>

function! JavaFormatParagraph()
    let old = winsaveview()
    normal mzvip
    let lines = line("'<") . ':' . line("'>")
    let &l:formatprg = "java -jar ~/.local/share/google-java-format-1.4-all-deps.jar -a --lines " . lines . " -"
    normal gggqG
    normal 'z
    call winrestview(old)
endfunction
