call pathogen#infect()          " Enable Pathogen
set nocompatible                " Disable vi compatibility
syntax on                       " Turn on Syntax Highlighting

filetype plugin indent on       " Use the plugin / indent for each type

let mapleader=','               " Use the , for leader

" Visual stuff
set background=dark             " Always assume a dark background
color vividchalk                " Use a more pleasing colorscheme

" Basic Settings
set encoding=utf-8              " Use utf-8 encoding
set relativenumber              " Use line numbers
set ruler                       " Show ruler for position
set visualbell                  " Stop the beeping!
set nowrap                      " Don't wrap lines
set backspace=indent,eol,start  " Allow backspace to work normally
set modelines=0                 " Ignore modelines
set cursorline                  " Highlight the current cursor position
set ttyfast                     " Assume we're using a fast terminal
set lazyredraw                  " Don't attempt to update screen during macros
set autowrite                   " Automatically write a file when leaving it
set formatoptions=or            " Be a bit smarter about comments
set scrolloff=5                 " Don't get too close to the edge!
set virtualedit=block           " Allow 'column-like selection in visual mode

" White Space
set nowrap                      " Don't wrap lines
set tabstop=4                   " Tabs are 4 spaces wide
set shiftwidth=4                " Automatic tabs are the same 4 spaces
set softtabstop=4               " Use 4 spaces for tabs
set expandtab                   " Use spaces instead of tab chars
set list                        " Show trailing whitespace
set listchars=tab:\ \ ,trail:·  " Ditto...
set autoindent                  " Automatic indention

" Searching
set hlsearch                    " Highlight search terms
set incsearch                   " Type-ahead find
set ignorecase                  " Case-insensitive search...
set smartcase                   " ...unless I specify caps chars
set gdefault                    " Assume I want to replace all instances
set wrapscan                    " Search will wrap

" Use perl-style regex (like everyone else...)
nnoremap / /\v
vnoremap / /\v

set wildmode=list:longest,list:full
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

" Status bar
set laststatus=2                " Always show the status bar
set showcmd                     " Show (partial) command in the status line
set showmode                    " Show the current mode
set statusline=%f               " Path
set statusline+=%m              " Modified flag
set statusline+=%r              " Readonly flag
set statusline+=%w              " Preview window flag
set statusline+=\    " Space.

set statusline+=%#redbar#                " Highlight the following as a warning.
set statusline+=%{SyntasticStatuslineFlag()} " Syntastic errors.
set statusline+=%*                           " Reset highlighting.

set statusline+=%=              " Right align
set statusline+=(%{&ft})        " Show file type

" Line and column position and counts.
set statusline+=\ (line\ %l\/%L,\ col\ %03c)


" Splits
set equalalways                 " Automatically size splits equally
set splitbelow                  " Create vsplits below current split
set splitright                  " Create splits right of current split

" Backups
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Undo
set undofile                    " Allow persistent undo
set undodir=~/.vim/undo         " Store undo files here
set undoreload=10000            " 10000 levels of undo!

" Clear search highlights
noremap <leader><space> :noh<cr>

" Use H and L to get to the beginning and end of the text on a line
noremap H ^
noremap L g_

" Strip trailing whitespace
map <leader>W  :%s/\s\+$//<cr>:let @/=''<CR>

" File-wide replace
nnoremap <leader>sr :%s/

" Reslect
nnoremap <leader>V V`]

" Faster esc that I'll try to get used to
inoremap jk <esc>

" Resize splits when the window is resized
augroup resized
    autocmd!
    au VimResized * exe "normal! \<c-w>="
augroup END

" Working with splits
nnoremap <leader>w :vsplit<cr>
nnoremap <leader>s :split<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <leader>q :close<cr>

" Quick editing for .vimrc
nnoremap <leader>ev <C-w>v<C-w>l<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Easier indentation
vnoremap > >gv
vnoremap < <gv
vnoremap = =gv

" Shrink the current window to fit the number of lines in the buffer.  Useful
" for those buffers that are only a few lines
nmap <silent> ,sw :execute ":resize " . line('$')<cr>

" Opens an edit command with the path of the currently edited file filled in
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Fast paste from system clipboard
nnoremap <Leader>p "*p
nnoremap <Leader>P "*P

" Uppercase the last word from insert mode - useful for constants
inoremap <C-u> <esc>viwUea

" Custom Filetypes
augroup filetypes
    autocmd!
    au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby
    au BufNewFile,BufRead *.json set ft=javascript
augroup END

" plugin: Command-T
let g:CommandTMaxHeight=20
nnoremap <Leader>t :CommandT<cr>
nnoremap <Leader>b :CommandTBuffer<cr>

" plugin: Ack.vim
nnoremap <Leader>a :Ack 

" plugin: gist-vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

" plugin: NERDTree
nnoremap <Leader>n :NERDTreeToggle<cr>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
augroup NerdTree
    autocmd!
    au FileType nerdtree setlocal nolist
augroup END

" plugin: Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=0
let g:syntastic_auto_loc_list=0
let g:syntastic_disabled_filetypes = ['scss', 'css']
nnoremap <leader>lc :lclose<cr>

" plugin: Gundo
nnoremap <Leader>u :GundoToggle<cr>

" plugin: YankRing
nnoremap <Leader>y :YRShow<cr>

" Perforce Stuff
function P4Checkout()
    set ar
    silent !p4 edit %
    set noreadonly
endfunction

augroup Perforce
    autocmd!
    au FileChangedRO * call P4Checkout()
augroup END
