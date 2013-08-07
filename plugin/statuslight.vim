let s:white         = '#ffffff'
let s:gray          = '#2f2f2f'
let s:light_gray    = '#939999'
let s:red           = '#c82829'
let s:orange        = '#f5871f'
let s:yellow        = '#eab700'
let s:green         = '#718c00'
let s:aqua          = '#3e999f'
let s:blue          = '#4271ae'
let s:purple        = '#8959a8'

" Regular User1
let s:group1_bg = s:green
let s:group1_fg = s:white

" Regular statusline
let s:statusline_bg = s:gray
let s:statusline_fg = s:white

" NERDTree statusline
let s:nerdstatus_bg = s:green
let s:nerdstatus_fg = s:white

" NC User1 
let s:group1_nc_bg = s:gray
let s:group1_nc_fg = s:light_gray

" NC statusline
let s:statusline_nc_bg = s:gray
let s:statusline_nc_fg = s:light_gray

" NC NERDTree statusline
let s:nerdstatus_nc_bg = s:gray
let s:nerdstatus_nc_fg = s:green

" Insert mode User1
let s:group1_i_bg = s:white
let s:group1_i_fg = s:blue

" Insert mode statusline
let s:statusline_i_bg = s:white
let s:statusline_i_fg = s:blue

" Replace mode User1
let s:group1_r_bg = s:red
let s:group1_r_fg = s:white

" Replace mode statusline
let s:statusline_r_bg = s:red
let s:statusline_r_fg = s:white

" Replace mode statusline
let s:ctrlp_fg = s:purple
let s:ctrlp_bg = s:white

" Replace mode statusline
let s:ctrlpcurrent_fg = s:white
let s:ctrlpcurrent_bg = s:purple

" This function runs when use changes insert status (insert or replace)
function! statuslight#InsertStatuslineColor(mode)
    echom a:mode
    if a:mode == 'i'
        call statuslight#Hi('User1', s:group1_i_fg, s:group1_i_bg)
        call statuslight#Hi('statusline', s:statusline_i_fg, s:statusline_i_bg)
    elseif a:mode == 'r'
        call statuslight#Hi('statusline', s:statusline_r_bg, s:statusline_r_fg)
        call statuslight#Hi('User1', s:statusline_r_bg, s:statusline_r_fg)
    endif
endfunction

function! statuslight#ResetStatusLineColor()
    call statuslight#Hi('User1', s:group1_fg, s:group1_bg)
    call statuslight#Hi('statusline', s:statusline_bg, s:statusline_fg)

    call statuslight#Hi('User1nc', s:group1_nc_fg, s:group1_nc_bg)
    call statuslight#Hi('statuslinenc', s:group1_nc_bg, s:group1_nc_fg)

    call statuslight#Hi('nerdstatus', s:nerdstatus_fg, s:nerdstatus_bg)

    call statuslight#Hi('ctrlp', s:ctrlp_bg, s:ctrlp_fg)
    call statuslight#Hi('ctrlpcurrent', s:ctrlpcurrent_bg, s:ctrlpcurrent_fg)
endfunction

function! statuslight#HighlightNERD()
    if &ft == 'nerdtree'
        call statuslight#Hi('nerdstatus', s:nerdstatus_fg, s:nerdstatus_bg)
    else
        call statuslight#Hi('nerdstatus', s:nerdstatus_nc_fg, s:nerdstatus_nc_bg)
    endif
endfunction

function! statuslight#RestoreStatusLine()
    if &ft != 'nerdtree'
        setlocal statusline=%1*\ %f\ 
        call statuslight#FinishStatusLine()
    end
endfunction

function! statuslight#HideStatusLine()
    if &ft != 'nerdtree'
        setlocal statusline=%#User1nc#\ %f\ 
        call statuslight#FinishStatusLine()
    end
endfunction

function! statuslight#FinishStatusLine()
    setlocal statusline+=%m%{statuslight#SpaceIf(&mod)}
    setlocal statusline+=%{statuslight#SpaceIf(&readonly)}%*
    if exists('g:loaded_fugitive')
        setlocal statusline+=\ %{statuslight#GetBranch()}
    endif
    setlocal statusline+=\ %=                        " align left
    setlocal statusline+=\ %{tolower(&ft)}\ |
    setlocal statusline+=\ LN\ %c:%l\              " Buffer number
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

" Set NERDTree status line
let NERDTreeStatusline="%#nerdstatus#%{exists('b:NERDTreeRoot')?b:NERDTreeRoot.path.str():''}"

" Set ctrlp status line
let g:ctrlp_status_func = { 'main': 'CtrlP_Statusline_1', }

" Hide/Restore statusline colors on which buffer is selected
au BufEnter * call statuslight#RestoreStatusLine()
au BufLeave * call statuslight#HideStatusLine()


" Check NERDTree for highlight changes, similar to above
au BufEnter * call statuslight#HighlightNERD()
au BufLeave * call statuslight#HighlightNERD()
au BufCreate * call statuslight#HighlightNERD()

" Reset qcolors when we start
au VimEnter * call statuslight#ResetStatusLineColor()
au VimEnter * call statuslight#HighlightNERD()
au VimEnter * call statuslight#RestoreStatusLine()


au InsertEnter * call statuslight#InsertStatuslineColor(v:insertmode)
au InsertLeave * call statuslight#ResetStatusLineColor()

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

