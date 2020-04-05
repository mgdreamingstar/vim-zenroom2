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

    let yellow='#F1C40F'
    let blue='#3498DB'
    let purple='#9B59B6'

    syn clear
    syn match code /```/
    syn match code /```python/
    syn region math start="\$" end="\$" oneline
    syn region bold start=/\*\*/ end=/\*\*/
    syn region header matchgroup=header_d start=/^#\{1,6}/ end=/$/

    colorscheme pencil
    "hi htmlH1 gui=bold
    "hi htmlH3 gui=bold
    "hi htmlH4 gui=bold
    "hi mkdSnippetPYTHON guifg=#3498DB
    "hi texStatement guifg=#3498DB
    "hi mkdListItem guifg=#F1C40F
    "hi htmlBold guifg=#9B59B6
    hi code guibg=yellow
    hi math guifg=blue
    hi bold guifg=purple
    hi header guifg=blue

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
