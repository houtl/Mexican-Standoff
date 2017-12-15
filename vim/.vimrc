"Numéros de lignes
set nu
"Coloration syntaxique
syntax on
set wildmenu

"C indent
set cindent
set noexpandtab

set ruler
set cursorcolumn

"Full parentheses
inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap < <><LEFT>

"Highlight des elements
highlight RedundantSpaces  ctermbg=red guibg=red
match RedundantSpaces /\ \+\ \|\s\+$/

"On enregistre les fichiers de backup[~]/swap[.swp] dans '~/.vim/tmp/'
set backup
if !isdirectory($HOME . "/.vim/tmp")
	call mkdir($HOME . "/.vim/tmp", "p")
endif
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/tmp/


function! Complete(s)
	let r = "/*   "
	let r .= a:s
	while strlen(r) < 50
		let r .= " "
	endwhile
	return r
endfunction

function! HeaderIsValid()
	let top = getline(0, 12)
    let USER=$USER
	let MAIL=$MAIL
	if top[0] != "/* ************************************************************************** */"
		return 0
	endif

	if top[1] != "/*                                                                            */"
		return 0
	endif

	if top[2] != "/*                                                        :::      ::::::::   */"
		return 0
	endif
	if top[3] != Complete(expand("%:t")) . "      :+:      :+:    :+:   */"
		return 0
	endif
	if top[4] != "/*                                                    +:+ +:+         +:+     */"
		return 0
	endif
	if top[5] != Complete("By: " . USER . " <" . MAIL . ">") . "  +#+  +:+       +#+        */"
		return 0
	endif
	if top[6] != "/*                                                +#+#+#+#+#+   +#+           */"
		return 0
	endif
	if !(top[7] =~ "/\*   Created: " && top[7] =~ "*/" && top[7] =~ "#+#" && top[7] =~ "by")
		return 0
	endif
	if (strlen(top[7]) != 80 || strlen(top[8]) != 80)
		return 0
	endif
	if !(top[8] =~ "/\*   Updated: " && top[8] =~ "*/" && top[8] =~ "###" && top[8] =~ "########.fr" && top[8] =~ "by")
		return 0
	endif
	if top[9] != "/*                                                                            */"
		return 0
	endif
	if top[10] != "/* ************************************************************************** */"
		return 0
	endif
	return 1
endfunction

function! InsertHeader()
	if !HeaderIsValid()
		let USER=$USER
		let MAIL=$MAIL
		let DATE=strftime("%Y/%m/%d %T")
		call append(0, "/* ************************************************************************** */")
		call append(1, "/*                                                                            */")
		call append(2, "/*                                                        :::      ::::::::   */")
		call append(3, Complete(expand("%:t")) . "      :+:      :+:    :+:   */")
		call append(4, "/*                                                    +:+ +:+         +:+     */")
		call append(5, Complete("By: " . USER . " <" . MAIL . ">") . "  +#+  +:+       +#+        */")
		call append(6, "/*                                                +#+#+#+#+#+   +#+           */")
		call append(7, Complete("Created: " . DATE . " by " . USER ) . "     #+#    #+#             */")
		call append(8, Complete("Updated: " . DATE . " by " . USER ) . "    ###   ########.fr       */")
		call append(9, "/*                                                                            */")
		call append(10, "/* ************************************************************************** */")
	endif
endfunction

function! UpdateHeader()
	let updated = getline(9)
	if &modified && !empty(matchstr(updated, "  Updated: ")) 
		let USER=$USER
		let DATE=strftime("%Y/%m/%d %T")
		9d
		call append(8, Complete("Updated: " . DATE . " by " . USER ) . "    ###   ########.fr       */")
	endif
endfunction

map <C-C><C-H> :call InsertHeader()<CR>
:autocmd! BufWritePre *.c :call UpdateHeader()
