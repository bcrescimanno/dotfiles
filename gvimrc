if has("gui_macvim")
    "Fullscreen to the entire screen
    set fuoptions=maxhorz,maxvert

    " Use a decent font
    "set guifont=Menlo\ Regular:h12
    set guifont=Droid\ Sans\ Mono:h12

    " Command-Enter for full screen
    macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-CR>

    " No Toolbar
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R

    " Command-T 
    macmenu &File.New\ Tab key=<D-T>
    map <D-t> :CommandT<CR>

    " NERD Commenter
    map <D-/> <plug>NERDCommenterToggle<CR>
    imap <D-/> <Esc><plug>NERDCommenterToggle<CR>i>


endif

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
    let explicitDirectory = isdirectory(a:directory)
    let directory = explicitDirectory || empty(a:directory)

    if explicitDirectory
        exe "cd " . fnameescape(a:directory)
    endif

    " Allows reading from stdin
    " ex: git diff | mvim -R -
    if strlen(a:directory) == 0 
        return
    endif

    if directory
        NERDTree
        wincmd p
        bd
    endif

    if explicitDirectory
        wincmd p
    endif
endfunction

augroup graphicalopen
    autocmd!
    autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
augroup END
