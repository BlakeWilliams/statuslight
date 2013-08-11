function! statuslight#FinishStatusLine()
  set statusline=%f\ 
  set statusline+=%m%{statuslight#SpaceIf(&mod)}
  set statusline+=%{statuslight#SpaceIf(&readonly)}%*
  set statusline+=\ %=                        " align left
  if exists('g:loaded_fugitive')
    set statusline+=\ %{statuslight#GetBranch()}
  endif
  set statusline+=\ %=                        " align left
  "set statusline+=\ %{tolower(&ft)}\ |
endfunction

" focus, byfname, s:regexp, prv, item, nxt, marked
" a:1    a:2      a:3       a:4  a:5   a:6  a:7
fu! CtrlP_Statusline_1(...)
  let prv = '%#ctrlp# '.a:4.' %*'
  let item = '%#ctrlpcurrent# '.a:5.' %*'
  let nxt = '%#ctrlp# '.a:6.' '
  let dir = ' %=%<%*%#ctrlp# '.getcwd().' %*'
  retu prv.item.nxt.dir
endf
let g:ctrlp_status_func = { 'main': 'CtrlP_Statusline_1', }

" Set NERDTree status line
let NERDTreeStatusline="%#nerdstatus#%{exists('b:NERDTreeRoot')?b:NERDTreeRoot.path.str():''}"

" Setup statusline
call statuslight#FinishStatusLine()

" Start utility functions
function! statuslight#GetBranch()
  let ret = substitute(fugitive#statusline(), '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', 'BR:' .' \1', 'g')
  return ret
endfunction

function! statuslight#SpaceIf(bool)
  if a:bool
    return ' '
  endif
  return ''
endfunction

function! statuslight#Hi(group, fg, bg) 
  exe 'hi! ' . a:group . ' guifg=' . a:fg . ' guibg=' . a:bg
endfunction
