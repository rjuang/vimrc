"{{{Startup Modules
set nocompatible
filetype off

" Enable Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Required Vundle
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

Plugin 'Raimondi/delimitMate'
Plugin 'Shougo/neocomplcache'
Plugin 'fatih/vim-go'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'majutsushi/tagbar'
Plugin 'marijnh/tern_for_vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'pthrasher/conqueterm-vim'

call vundle#end()

" Turn on FileType plugin for enabling autocmd by filetype.
filetype plugin indent on
"}}}
"{{{Functions
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    end
    return ''
endfunction

function! EvalPythonInPreview() range
    "Force preview window to close.
    pclose!
    silent %y a | below new | silent put a | silent %!python -
    " Indicate the output window as the current preview window
    setlocal previewwindow ro nomodifiable nomodified
    set nonumber
    file OUTPUT
    " Set cursor to the original window
    wincmd p
endfunction

function! OpenTerminal() range
    let cwd = expand('%:p:h')
    let term = conque_term#open('/bin/bash', ['belowright split', 'resize 10'])
    call term.writeln('cd '.cwd)
    call term.writeln('clear')
endfunction
"}}}
"{{{Auto Commands
augroup vimrc_autocmd_group
    autocmd!
    " Automatically cd into the directory that the file is in
    autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

    " Remove any trailing whitespace that is in the file
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

    " Enable F5 key to save and execute the current python script.
    autocmd FileType python map [15~ :call EvalPythonInPreview()<cr>
    autocmd FileType python imap [15~ <esc>:call EvalPythonInPreview()<cr>

    " Remap # in visual mode for commenting
    autocmd FileType python vnoremap # :s#^#\##<cr>
    autocmd FileType python vnoremap -# :s#^\###<cr>

    " Return to last edit position when opening files.
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif

    " Gradle files
    autocmd BufNewFile,BufRead *.gradle setf groovy

    " Mapping for Golang
    autocmd FileType go nmap <leader>r <Plug>(go-run)
    autocmd FileType go nmap <leader>b <Plug>(go-build)
    autocmd FileType go nmap <leader>t <Plug>(go-test)
    autocmd FileType go nmap <leader>c <Plug>(go-coverage)
    autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
    autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
    autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
    autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    autocmd FileType go nmap <Leader>gb <Plug>(go-doc-browser)
    autocmd FileType go nmap <Leader>s <Plug>(go-implements)
    autocmd FileType go nmap <Leader>i <Plug>(go-info)
    autocmd FileType go nmap <Leader>e <Plug>(go-rename)
augroup END
"}}}
"{{{VIM Behavioural Settings
" Remember info about open buffers on close. Needed for restoring last edit
" position on opening files.
set viminfo^=%

" Necessary for lots of cool vim things
set nocompatible

" This shows what you are typing as a command.
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting
filetype on
filetype plugin on
syntax enable

set grepprg=grep\ -nH\ $*

" Auto indentation
set autoindent

" Spaces are better than tab
set expandtab
set smarttab

" Tab completion for command-line menu
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*~,*.pyc

" Enable mouse support in console
" set mouse=a

" Ignore case
set ignorecase
set smartcase

"Incremental searching
set incsearch

" Remove buffer when closing tab
set nohidden

" Sets how many lines of history VIM has to remember.
set history=700

" Configure backspace so it acts as it should act.
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" For performance, don't redraw while executing macros.
" Note: This causes issues
"set lazyredraw

" For regular expressions turn magic on
set magic

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac
" }}}
"{{{Plugin Settings

" ---- YouCompleteMe -----
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'

" ---- ConqueTerm --------
" Disable any startup warning messages
let g:ConqueTerm_StartMessages = 0

" ---- Tagbar for Go -----
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

"------- vim-go Settings -----------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_disable_autoinstall = 0

let g:go_fmt_command = "goimports"
"}}}
"{{{Look and Feel
" Set line numbers
set number

" Fix tab spacing
set shiftwidth=4
set softtabstop=4

" Highlight search results
set hlsearch

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Highlight other paren
highlight MatchParen ctermbg=4

" Always show current position.
set ruler

" Show matching brackets when text indicator is over them.
set showmatch

" How many tenths of a second to blink when matching brackets.
set matchtime=2

" Prevent long lines from automatically being broken.
set textwidth=0

" Status line (always show status line)
set laststatus=2
set statusline=\ %{HasPaste()}%<%f%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l,%c

" Create a red boundary at column 81
set colorcolumn=81
highlight ColorColumn ctermbg=DarkRed guibg=DarkRed

set errorformat+=%f:%l:%m

" No annoying sound on errors.
set noerrorbells
set visualbell
set timeoutlen=500

" Color scheme
colorscheme molokai
"colorscheme desert
"set background=dark

if has("gui_running")
    set guioptions-=T  " Removes top toolbar
    set guioptions-=r  " Removes right hand scroll bar
    set guioptions-=L  " Removes left hand scroll bar
    set guioptions+=e  " Show tabs
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=Monaco:h13
    colorscheme codeschool
endif
" }}}
"{{{ Key Bindings

"Use comma as leader key
let g:mapleader = ","

"<leader>ev for editing vimrc
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

"<leader>rv for reloading vimrc
nnoremap <silent> <Leader>rv :source $MYVIMRC<CR>

" Up and down make more sense with g.
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Space to toggle folds.
nnoremap <space> za

" Alter search behaviour to center on line of result.
map N Nzz
map n nzz

" <leader>w for write
nnoremap <leader>w :w!<CR>

" <leader>k for quit
nnoremap <leader>q :q<CR>

" remap H for jump to beginning of line
nnoremap H 0

" remap L for jump to end of line
nnoremap L $

" Make it easier to navigate between split windows.
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

" Navigate between tabs:
nnoremap <silent> <Left> :tabprevious<cr>
nnoremap <silent> <Right> :tabnext<cr>
nnoremap <silent> <C-t> :tabnew<cr>

" Create blank newlines and stay in normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" <C-p> to toggle between paste mode during insert.
set pastetoggle=<F2>

" Remap ESC in visual mode to <etner> key
vnoremap <enter> <Esc>
" <leader><enter> for Getting rid of highlighted search
nnoremap <silent> <Leader><cr> :nohlsearch<cr>
" Swap ; and : to avoid hitting shift when entering commands
nnoremap ; :
nmap <F8> :TagbarToggle<CR>
map <C-n> :NERDTreeToggle<CR>

" Map F6 key for loading a bash subwindow
nnoremap <F6> :call OpenTerminal()<cr>
augroup vimrc_bash_window_group
    autocmd!
    autocmd FileType python map <F5> :call EvalPythonInPreview()<cr>
augroup END

" Remap jk to escape in insert mode.
inoremap jk <Esc>
"}}}

syntax enable
