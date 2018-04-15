" Gotta be first
set nocompatible

" Set up Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Making vim look good
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Vim as a programmer's editor
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-syntastic/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Other text editing features
Plugin 'Raimondi/delimitMate'

" Man pages, tmux
Plugin 'jez/vim-superman'
Plugin 'christoomey/vim-tmux-navigator'

" Syntax plugins
Plugin 'jez/vim-c0'
Plugin 'jez/vim-ispc'
Plugin 'kchmck/vim-coffee-script'

call vundle#end()

filetype plugin indent on

" General settings
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set ignorecase
set smartcase

set encoding=utf-8
set visualbell

nnoremap / /\v
vnoremap / /\v

" Tabs/space settings
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab
set wrap
set textwidth=79
set noshiftround
set smarttab

" 'no one is really happy until you have all these shortcuts'
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

syntax on

" Enable scrolling
set mouse=a

" Needed for plugins like Syntastic and vim-gitgutter
hi clear SignColumn

" Plugin-specific settings
" Altercation/vim-colors-solarized
set background=dark
let g:solarized_termcolors=256

colorscheme molokai

" vim-airline
set laststatus=2

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Use solarized theme for airline status bar
let g:airline_theme='solarized'

" Nerdtree tabs
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" NERDTree open on startup
let g:nerdtree_tabs_open_on_console_startup=1

" scrooloose/syntastic
let g:syntastic_error_symbol = 'X'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
	au!
	au FileType tex let b:syntastic_mode = "passive"
augroup END

" xolox/vim-easytags
" Where to look for tag files
set tags=./tags;,~/.vimtags
" Defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 1
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warnings = 1

" majutsushi/tagbar
" Open/close tagbar with <leader>b
nmap <silent> <leader>b :TagbarToggle<CR>

" airblade/vim-gitgutter settings
let g:airline#extensions#hunks#non_zero_only = 1

" Ramondi/delimitMate
let delimitMate_expand_cr = 1
augroup mydelimitMate
	au!
	au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
	au FileType tex let b:delimitMate_quotes = ""
	au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
	au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" jez/vim-superman
noremap K :SuperMan <cword><CR>

