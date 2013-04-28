let s:white = "ffffff"
let s:gray = "2f2f2f"
let s:light_gray = "939999"

let s:red = "c82829"
let s:orange = "f5871f"
let s:yellow = "eab700"
let s:green = "718c00"
let s:aqua = "3e999f"
let s:blue = "4271ae"
let s:purple = "8959a8"

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
        call <SID>X("User1", s:group1_i_fg, s:group1_i_bg)
        call <SID>X("statusline", s:statusline_i_fg, s:statusline_i_bg)
    elseif a:mode == 'r'
        call <SID>X("statusline", s:statusline_r_bg, s:statusline_r_fg)
        call <SID>X("User1", s:statusline_r_bg, s:statusline_r_fg)
    endif
endfunction

function! statuslight#ResetStatusLineColor()
    call <SID>X("User1", s:group1_fg, s:group1_bg)
    call <SID>X("statusline", s:statusline_bg, s:statusline_fg)

    call <SID>X("User1nc", s:group1_nc_fg, s:group1_nc_bg)
    call <SID>X("statuslinenc", s:statusline_nc_bg, s:statusline_nc_fg)

    call <SID>X("nerdstatus", s:nerdstatus_fg, s:nerdstatus_bg)

    call <SID>X("ctrlp", s:ctrlp_bg, s:ctrlp_fg)
    call <SID>X("ctrlpcurrent", s:ctrlpcurrent_bg, s:ctrlpcurrent_fg)
endfunction

function! statuslight#HighlightNERD()
    if &ft == 'nerdtree'
        call <SID>X("nerdstatus", s:nerdstatus_fg, s:nerdstatus_bg)
    else
        call <SID>X("nerdstatus", s:nerdstatus_nc_fg, s:nerdstatus_nc_bg)
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

" Reset colors when we start
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

" Stolen color functions from desert
if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " Returns an approximate grey index for the given grey level
    function! <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfunction

    " Returns the actual grey level represented by the grey index
    function! <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfunction

    " Returns the palette index for the given grey index
    fun <SID>grey_colour(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfunction

    " Returns an approximate colour index for the given colour level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfunction

    " Returns the actual colour level for the given colour index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfunction

    " Returns the palette index for the given R/G/B colour indices
    fun <SID>rgb_colour(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfunction

    " Returns the palette index to approximate the given R/G/B colour levels
    fun <SID>colour(r, g, b)
        " Get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " Get the closest colour
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " There are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " Use the grey
                return <SID>grey_colour(l:gx)
            else
                " Use the colour
                return <SID>rgb_colour(l:x, l:y, l:z)
            endif
        else
            " Only one possibility
            return <SID>rgb_colour(l:x, l:y, l:z)
        endif
    endfunction

    " Returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>colour(l:r, l:g, l:b)
    endfunction

    " Sets the highlighting for the given group
    fun <SID>X(group, fg, bg) ", attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
       " if a:attr != ""
       "     exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
       " endif
    endfunction
endif
