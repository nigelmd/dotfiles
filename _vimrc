source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"Windows specific
set backup
set backupdir=C:\WINDOWS\Temp
set backupskip=C:\WINDOWS\Temp\*
set directory=C:\WINDOWS\Temp
set undodir=C:\WINDOWS\Temp
set writebackup

set nocompatible              						            "Always fetch latest Vim settings, required for Vundle

so $VIMRUNTIME/plugin/plugins.vim							                "Source the vundle configuration so it's read on startup

syntax enable

set backspace=indent,eol,start						            "Backspace enabled like other editors
let mapleader= ','							                    "Default leader is \, but comma is much easier to access

"---------------------------Visuals--------------------"
if has('gui_running')                                           "Use atom-dark only if no gui
    set background=dark
endif

colorscheme brogrammer                                          "marciomazza/vim-brogrammer-theme
set t_Co=256								                    "Use 256 colors. Useful for terminal Vim
set number                                                      "Set line numbers
set complete=.,w,b,u                                            "Set the desired autocompletion

set guioptions-=l							                    "Remove vertical scroll bars on left and right
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=R

"Keep line numbers background same color as bg, use only if required
"hi LineNr ctermbg=black

"Set padding on left for each window
"set foldcolumn=2                                               "Set only if not using linenumbers

"Set padding background to be equal to background color
"hi foldcolumn ctermbg=black

"Set vertical split to not have gray foreground, just dotted lines as white
hi vertsplit ctermfg=black ctermbg=white

"
"define BadWhitespace before using in a match and autocmd to remove before "writing to the file
highlight BadWhitespace ctermbg=red guibg=darkred
autocmd BufWritePre * %s/\s\+$//e

set expandtab           						                "Spaces instead of tabs
set tabstop=4           						                "Use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        						                "Number of spaces for auto indent
set autoindent          						                "Copy indent from current line when starting a new line

" Enable folding
set foldmethod=indent
set foldlevel=99

"---------------------------Search--------------------"
set hlsearch
set incsearch								                    "Highlight and take cursor to word if found

"Remove previous highlighted search
nmap <Leader><space> :nohlsearch<cr>

"Ignore case
set ic

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
map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<cr>

"Quit insert mode and write to file
imap ww <Esc>:w<cr>

"---------------------------Plugins---------------"

" Syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_mode_map = { 'active_filetypes': [],'passive_filetypes': [] }
" IDE like settings
nmap <F5> :SyntasticCheck<CR>
nmap <F6> :SyntasticToggleMode<CR>

"/
"/ CtrlP
"
let g:ctrlp_custom_ignore = 'node_modules\DS_Store\|git'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:30,results:30'

nmap <C-p> :CtrlP<cr>
nmap <C-R> :CtrlPBufTag<cr>
nmap <C-e> :CtrlPMRUFiles<cr>

"/
"/ NERDTree
"
let NERDTreeHijackNetrw = 0
let NERDTreeIgnore=['\.pyc$', '\~$']                            "Ignore .pyc files
let NERDTreeShowHidden=1

"Easier NERDTree toggle
nmap <Leader>n :NERDTreeToggle<cr>

"/
"/ Ctags
"
nmap <Leader>f :tag<space>

"/
"/ Greplace.vim
"
set grepprg=ag                                                  "Using Ag for search
let g:grep_cmd_opts = '--line-numbers --noheading'

"/
"/ Powerline
"
"set guifont=Inconsolata\ for\ Powerline:h10
set guifont=Droid\ Sans\ Mono\ for\ Powerline:h9
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set laststatus=2
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8

"/
"/ Airline
"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
nmap <Leader><Tab> :bn<CR>

"/
"/ SimplyFold
"
let g:SimpylFold_docstring_preview=1
" Enable folding with the spacebar
nnoremap <space> za

"/
"/ VirtualEnv
"
let g:virtualenv_directory = '$HOME/venvs'
let g:virtualenv_stl_format = '(%n)'
set statusline+=%{virtualenv#statusline()}

"/
"/ Syntastic
"
set statusline=%f
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_compiler_options = ' --std=c++11'
let g:syntastic_python_checkers = ['pylint', 'pyflakes']

"---------------------------Auto-Commands---------------"

"Automatically source Vimrc file on save
augroup autosourcing
	autocmd!
    autocmd BufWritePost .vimrc source %
    autocmd BufRead,BufNewFile *.py let python_highlight_all=1
augroup END

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Inconsolata\ for\ Powerline:h15
   endif
endif

"----------------------Commands-------------------------"

nmap <leader>d :bprevious<CR>:bdelete #<CR>

"Always source gvimrc last, or after all non-gui specific settings
so $VIM/_gvimrc

"Quick escape to normal mode
imap jj <Esc>

"Notes and tips
" - zz to center the line where the cursor is
" - Ctrl^ for switching cursor back to where it was after going to a new file
" - tn, tp for next and previous tag
" - ts for selecting from the list of tags
" - gt for toggling between buffers
" - c,v,d + a + i and any character pair, will change, highlight or delete, but
"   including the character pair
" - Ctrl] for going to method when cursor is on method
" - C-o for making current buffer fullscreen
" - Shift-j joins the line below to the current line
" - '0 takes you back to the same point of a file when you last closed vim
