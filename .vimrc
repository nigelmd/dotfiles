set nocompatible              						            "Always fetch latest Vim settings, required for Vundle

so ~/.vim/plugins.vim							                "Source the vundle configuration so it's read on startup

syntax enable

set backspace=indent,eol,start						            "Backspace enabled like other editors
let mapleader= ','							                    "Default leader is \, but comma is much easier to access

"---------------------------Visuals--------------------"
colorscheme atom-dark
set t_CO=256								                    "Use 256 colors. Useful for terminal Vim
set number								                        "Set line numbers
set linespace=12							                    "Mac-vim specific line height
set guifont=Fira_Code:h12						                "For mac-vim
set macligatures							                    "For pretty symbols, when available
set guioptions-=e							                    "No gui tabs

set guioptions-=l							                    "Remove vertical scroll bars on left and right
set guioptions-=L
set guioptions-=r
set guioptions-=R

set expandtab           						                "Spaces instead of tabs 
set tabstop=4           						                "Use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        						                "Number of spaces for auto indent
set autoindent          						                "Copy indent from current line when starting a new line

"---------------------------Search--------------------"
set hlsearch
set incsearch								                    "Highlight and take cursor to word if found

"Remove previous highlighted search
nmap <Leader><space> :nohlsearch<cr>

"---------------------------Split--------------------"
set splitbelow
set splitright

"Go to splits using Ctrl-h,j,k,l
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"---------------------------Mappings--------------------"

"Easy to edit vimrc
nmap <Leader>ev :tabedit $MYVIMRC<cr>

"---------------------------Plugins---------------"

"/
"/ CtrlP
"
let g:ctrlp_custom_ignore = 'node_modules\DS_Store\|git'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:30,results:30'

nmap <D-p> :CtrlP<cr>
nmap <D-R> :CtrlPBufTag<cr>
nmap <D-e> :CtrlPMRUFiles<cr>

"/
"/ NERDTree
"
let NERDTreeHijackNetrw = 0

"Easier NERDTree toggle
nmap <Leader>n :NERDTreeToggle<cr>

"---------------------------Auto-Commands---------------"

"Automatically source Vimrc file on save
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END

"Quick escape to normal mode 
imap jj <Esc>
