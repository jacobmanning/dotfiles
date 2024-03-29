" Set up Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Making vim look good
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Vim as a programmer's editor
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
" Plugin 'vim-syntastic/syntastic'
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" C++ goodies
Plugin 'octol/vim-cpp-enhanced-highlight'

" Other text editing features
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-sleuth'

" Man pages, tmux
" Plugin 'jez/vim-superman'
Plugin 'christoomey/vim-tmux-navigator'

" Syntax plugins
Plugin 'jez/vim-c0'
Plugin 'jez/vim-ispc'
Plugin 'kchmck/vim-coffee-script'
Plugin 'rhysd/vim-clang-format'

" Rust
Plugin 'rust-lang/rust.vim'

" Extra colorschemes
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'jacoborus/tender.vim'
Plugin 'dracula/vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'drewtempelmeyer/palenight.vim'

call vundle#end()

" Vim Plug
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
" Plug 'xavierd/clang_complete'
" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neomake/neomake'
call plug#end()

function! MyOnBattery()
  " Only on linux I think
  " return readfile('/sys/class/power_supply/AC/online') == ['0']
  return 1
endfunction

if MyOnBattery()
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif

" General settings
set number relativenumber
set ignorecase
set smartcase

" No one wants a bell
set visualbell
set noeb vb t_vb=

nnoremap / /\v
vnoremap / /\v

" Tabs/space settings
set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab
"set wrap
"set textwidth=79
set noshiftround
set autoindent
set copyindent

" Disable matching parentheses
let g:loaded_matchparen=1

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

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" nmap <silent> <leader><Tab> gt
" nmap <silent> <leader><S-Tab> gT
" nnoremap <silent> <S-t> :tabnew<CR>

" open file in new tab
nmap <leader>g <c-w>gf

syntax on

" Enable scrolling
" set mouse=a

" Needed for plugins like Syntastic and vim-gitgutter
hi clear SignColumn

" Plugin-specific settings
" Altercation/vim-colors-solarized
set background=dark
let g:solarized_termcolors=256
let g:solarized_term_italics=0

" If you have vim >=8.0 or Neovim >= 0.1.5
" These were commented out for Argo setup
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" set termguicolors

" Set colorscheme
colorscheme dracula

" vim-airline
set laststatus=2

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Use theme for airline status bar
let g:airline_theme='dracula'

" Nerdtree tabs
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" NERDTree open on startup
let g:nerdtree_tabs_open_on_console_startup=1
" NERDTreeFind
nmap <leader>ntf :NERDTreeFind<cr>

" scrooloose/syntastic
" let g:syntastic_error_symbol = 'X'
" let g:syntastic_warning_symbol = "▲"
" augroup mySyntastic
" 	au!
" 	au FileType tex let b:syntastic_mode = "passive"
" augroup END

" xolox/vim-easytags
" Defaults
" let g:easytags_events = ['BufReadPost', 'BufWritePost']
" let g:easytags_async = 1
" let g:easytags_dynamic_files = 1
" let g:easytags_resolve_links = 1
" let g:easytags_suppress_ctags_warnings = 1

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
" noremap K :SuperMan <cword><CR>

" FZF
nmap <leader>f :Files<cr>
noremap <C-p> :Files<Cr>

set list

" Fix issues with tmux and dracula italics
let g:dracula_italic = 0
let g:dracula_colorterm = 0
colorscheme dracula
highlight Normal ctermbg=None

" Neomake
let g:neomake_error_sign = {
      \	'text': '✖',
      \	'texthl': 'NeomakeErrorSign',
      \	}

let g:neomake_warning_sign = {
      \	'text': '▲',
      \	'texthl': 'NeomakeWarningSign',
      \	}

" let g:neomake_cpp_enabled_makers = ['clangcheck', 'clangtidy']
" let g:neomake_cpp_clangtidy_maker = {
"       \ 'exe': 'clang-tidy',
"       \ 'args': ['-extra-arg-before=-std=c++17', '-checks=bugprone-*,cppcoreguidelines-*,clang-analyzer-*,google-*,hicpp-*,misc-*,modernize-*,performance-*,readability-*', '-header-filter=.*', '-quiet'],
"       \ }
" 
" let g:neomake_cpp_clangcheck_maker = {
"       \ 'exe': 'clang-check',
"       \ 'args': ['-extra-arg-before=-Wc++17-extensions','-extra-arg-before=-std=c++17'],
"       \ }

let g:neomake_python_pycodestyle_maker = {
  \ 'exe': 'pycodestyle',
  \ 'args': ['--max-line-length=120'],
  \ }

set matchpairs+=<:>

autocmd FileType cpp ClangFormatAutoEnable

" This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>
