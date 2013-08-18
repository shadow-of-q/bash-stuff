if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

" Use Vim defaults (much better!)
set nocompatible

" Allow backspacing over everything in insert mode
set bs=indent,eol,start

" Don't store more " than 50 lines of registers
set viminfo='20,\"50

" Keep 50 lines of command line history
set history=50

" Show the cursor position all the time
set ruler

" Show the line numbers
set number

" Highlight research
set hlsearch

" 80 columns
set textwidth=80

" Folding is enabled
set foldenable

" We use the syntax of the current language for the folding
set foldmethod=syntax

" Lazy redraw -> disable redraw during macro
set lazyredraw

" Disable any sound during errors
set noerrorbells

" Show mathcing brackets
set showmatch

" Match time equal to 0 otherwise, it is REALLY disturbing
set matchtime=0

" Set the tags files
" set tags=/usr/include/tags,./tags,~/include/tags,../tags,../../tags
set tags=tags

" Syntax highliting is enabled
syntax on
filetype plugin indent on

" Omni func for each language
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Take indent for new line from previous line
set autoindent

" Smart autoindenting for C programs
set smartindent

" Do c-style indenting
set cindent

" Tab spacing (settings below are just to unify it)
set tabstop=2

" Unify
set softtabstop=2

" Unify
set shiftwidth=2

" Spaces no TABS
set expandtab

" Do not wrap lines
set nowrap

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

" Display white space characters
set list
set listchars=tab:>-,trail:-,eol:<

" Set color theme
set background=dark
hi comment ctermfg=darkcyan cterm=NONE 						" Comments
hi Preproc ctermfg=darkmagenta cterm=NONE 					" Preprocessor
hi NonText ctermfg=darkblue cterm=NONE 						" End of line
hi SpecialKey ctermfg=darkblue cterm=NONE 					" Tabs, white spaces
hi Statement ctermfg=yellow cterm=bold						" If then else return ....
hi Search ctermbg=yellow ctermfg=black cterm=NONE 			" Search
hi IncSearch ctermfg=black ctermbg=yellow cterm=NONE		" Incremental Search
hi Type ctermfg=green cterm=bold
hi Constant ctermfg=magenta cterm=NONE
hi LineNr ctermfg=red cterm=NONE
hi OverLength ctermbg=darkred ctermfg=white cterm=NONE
match OverLength /\%82v.*/

" Shortcuts to change splits
map <C-H> <C-W><C-H>
map <C-J> <C-W><C-J>
map <C-K> <C-W><C-K>
map <C-L> <C-W><C-L>

" Regenerate tags
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iatS --extra=+fq . <CR>

" Set the paths for include research
set path=.,/usr/include/,/usr/local/include/

" set go environment
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

