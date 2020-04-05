"==============================================================================
"File:        zenroom2.vim
"Description: Emulates iA Writer environment when editing Markdown, reStructuredText
"             or text files.
"Maintainer:  Amir Salihefendic <amix@doist.io>
"Version:     0.1
"Last Change: 2013-12-29
"License:     BSD
"==============================================================================

if exists( "g:loaded_zenroom2_plugin" )
    finish
endif
let g:loaded_zenroom2_plugin = 1

let s:colo = g:colors_name

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"
" Save the current `background` value for reset later
let s:save_background = ""
if exists( "&background" )
    let s:save_background = &background
endif

function! s:markdown_room()
    set background=light
    set linespace=8 " number of pixel lines inserted between characters.

    let yellow1='#F2EDCA'
    let yellow2='#F1C40F'
    let blue1='#EBF5FB'
    let blue2='#3498DB'
    let purple1='#F5EEF8'
    let purple2='#9B59B6'
    let red1='#F1948A'
    let red2='#E74C3C'
    let gray='#E5E8E8'

    syn clear
    syn match code /```\(python\)\=/ oneline
    syn match math "\$\$" oneline
    syn region bold matchgroup=bold_d start=/\*\*/ end=/\*\*/ oneline
    syn region italic matchgroup=italic_d start=/\*\(\*\)\@!/ end=/\*\(\*\)\@!/ oneline
    syn region header matchgroup=header_d start=/^#\{1,6}/ end=/$/
    syn match  list_item    /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/

    syn region code2 start=/`\(`\)\@!/  end=/`\(`\)\@!/ oneline contains=CONTAINED
    syn region math2 start="\$\(\$\)\@!" end="\$\(\$\)\@!" contains=CONTAINED
    syn region blockquote   start=/^\s*>/  end=/$/
    syn region footnote     start="\[^"   end="\]"

    colorscheme pencil
    hi code guifg=yellow2
    hi math guifg=yellow2
    hi math2 guibg=yellow1
    hi list_item guifg=yellow2
    hi code2 guibg=purple1

    hi bold guifg=purple2
    hi bold_d guifg=purple1
    hi italic guifg=red2
    hi italic_d guifg=red1
    hi header gui=bold guifg=blue2

endfunction

function! zenroom2#Zenroom_goyo_before()
    if !exists('g:GuiLoaded')
        return
    endif
    let is_mark_or_rst = &filetype == "markdown" || &filetype == "vimwiki" || &filetype == "rst" || &filetype == "text"

    if is_mark_or_rst
        call s:markdown_room()
    endif
endfunction

function! zenroom2#Zenroom_goyo_after()
    if !exists('g:GuiLoaded')
        return
    endif
    let is_mark_or_rst = &filetype == "markdown" || &filetype == "vimwiki" || &filetype == "rst" || &filetype == "text"
    if is_mark_or_rst
        set linespace=0
        if s:save_background != ""
            exec( "set background=" . s:save_background )
        endif
    endif
    silent exec "colorscheme " . expand(s:colo)
    silent exec "AirlineTheme " . string(expand(s:colo))
    silent syn on
endfunction

let g:goyo_callbacks = [ function('zenroom2#Zenroom_goyo_before'), function('zenroom2#Zenroom_goyo_after') ]
