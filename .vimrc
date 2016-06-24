set nocompatible              						"Always fetch latest Vim settings, required for Vundle

so ~/.vim/plugins.vim							"Source the vundle configuration so it's read on startup

syntax enable

set backspace=indent,eol,start						"Backspace enabled like other editors
let mapleader= ','							"Default leader is \, but comma is much easier to access

"---------------------------Visuals--------------------"
colorscheme atom-dark
set t_CO=256								"Use 256 colors. Useful for terminal Vim
set number								"Set line numbers
set linespace=12							"Mac-vim specific line height
set guifont=Fira_Code:h12

set guioptions-=l							"Remove vertical scroll bars on left and right
set guioptions-=L
set guioptions-=r
set guioptions-=R

"---------------------------Search--------------------"
set hlsearch
set incsearch								"Highlight and take cursor to word if found

"Remove previous highlighted search
nmap <Leader><space> :nohlsearch<cr>

"---------------------------Split--------------------"
set splitbelow
set splitright

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"---------------------------Mappings--------------------"

"Easy to edit vimrc
nmap <Leader>ev :tabedit $MYVIMRC<cr>

"Easier NERDTree toggle
nmap <Leader>n :NERDTreeToggle<cr>

nmap <C-R> :CtrlPBufTag<cr>
nmap <D-e> :CtrlPMRUFiles<cr>

"---------------------------Auto-Commands---------------"

"Automatically source Vimrc file on save
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END

"Quick escape to normal mode 
imap jj <Esc>
