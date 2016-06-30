"Don't let print key shortcut take over CtrlP plugin in Macvim/Gvim
if has("gui_macvim")
	macmenu &File.Print key=<nop>
	set guifont=Fira_Code:h12						            "For mac-vim
    set macligatures							                "For pretty symbols, when available
endif

"---------------------------Visuals--------------------"

set linespace=12							                    "Mac-vim specific line height
set guioptions-=e							                    "No gui tabs

"Keep line numbers same color as bg
hi LineNr guibg=bg                                              
hi foldcolumn guibg=bg
hi vertsplit guifg=bg guibg=white