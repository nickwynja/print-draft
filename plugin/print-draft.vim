" Print markdown draft using pandoc
function! PrintDraft(...)
  let l:filename = expand('%:p')
  " If bang! save to file
  if a:0 > 0 && a:1 == 1
    "do not print
    exec "!pd -d " . l:filename
  elseif exists('a:2')
    exec "!pd -p " . a:2  l:filename
  else
    exec "!pd " . l:filename
  endif
endfunction
command! -nargs=* -bang PrintDraft call PrintDraft(<bang>0, <f-args>)
