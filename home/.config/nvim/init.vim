" my-dotfiles | Copyright (C) 2021 eth-p
" Repository: https://github.com/eth-p/my-dotfiles

filetype plugin on
call plug#begin()
	Plug 'itchyny/lightline.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-sleuth'
	Plug 'ojroques/vim-oscyank', {'branch': 'main'}

	" Git stuff.
	Plug 'rhysd/conflict-marker.vim'
	Plug 'airblade/vim-gitgutter'

	" Terminal stuff.
	Plug 'eth-p/vim-tmux'

	" Languages.
	Plug 'dag/vim-fish'
	Plug 'fatih/vim-go'
	Plug 'cespare/vim-toml'
	Plug 'digitaltoad/vim-pug'
	Plug 'google/vim-jsonnet'

	" Themes.
	Plug 'crusoexia/vim-monokai'  " Dark theme.
	Plug 'chiendo97/intellij.vim' " Light theme.

	" Ranger.
	Plug 'francoiscabrol/ranger.vim'
	if has('nvim') | Plug 'rbgrouleff/bclose.vim' | endif
call plug#end()


" -----------------------------------------------------------------------------
" Overrides:
" -----------------------------------------------------------------------------

	" If the TERM_BG environment variable is set, we should trust
	" that over what non-neo vim guesses the background color as.
	if $TERM_BG != "" && &background != $TERM_BG
		let &background=$TERM_BG
	end

	" File type overrides.
	au BufRead,BufNewFile $HOME/.config/tmux/*.conf setfiletype tmux


" -----------------------------------------------------------------------------
" General:
" -----------------------------------------------------------------------------

	set mouse=a			 " Enable mouse support.
	set whichwrap+=<,>,[,]  " Allow arrow keys to wrap lines.

	set shell=bash		  " Run scripts in bash, not fish.

	" Enable syntax.
	syntax enable
	filetype plugin indent on

	" Enable better status line with 'lightline'.
	set laststatus=2
	set noshowmode
	let g:hostname = trim(system("{ command -v hostname >/dev/null && hostname; } || cat /etc/hostname"))
	let g:lightline = {
	\	'active': {
	\		'left': [[ 'mode', 'paste' ], ['readonly', 'hostname', 'filename', 'modified'], [ 'git_status' ]]
	\	},
	\	'component_function': {
	\		'git_status': 'LLCustom_GitStatus',
	\       'hostname':   'LLCustom_Hostname'
	\	},
	\	'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\	'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
	\}

	function! LLCustom_GitStatus()
		let [a,m,r] = GitGutterGetHunkSummary()
		return printf('+%d ~%d -%d', a, m, r)
	endfunction

	function! LLCustom_Hostname()
		let l:hostname = substitute(g:hostname, '\.local$', '', '')
		if $SSH_CLIENT == ""
			return ""
		endif
		return l:hostname
	endfunction


	" Enable title.
	set title
	set titlestring=vim\ %F

	" Enable sidebar.
	set updatetime=0	" Immediately show the git sidebar.
	set number		  " Enable line numbers.
	set numberwidth=5   " Set the line number width.

	if has('nvim')
		autocmd User GitGutter GitGutterLineNrHighlightsEnable
	end

	" Adjust tabs.
	set tabstop=4
	set shiftwidth=4

	autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 cursorcolumn

	" Enable spell check for Markdown.
	autocmd FileType markdown setlocal spell spelllang=en_us

	" Highlight the 80th and 120th columns.
	set colorcolumn=80,120

	" Configure Monokai theme.
	let g:monokai_term_italic = 1

	" Don't have line numbers in terminal windows.
	if has('nvim')
		autocmd TermOpen * setlocal nonumber norelativenumber
	end

" -----------------------------------------------------------------------------
" Theme:
" -----------------------------------------------------------------------------

	if &background == "light"
		colorscheme intellij
		let g:lightline['colorscheme'] = 'one'
	else
		colorscheme monokai
		let g:lightline['colorscheme'] = 'powerline'

		highlight CursorColumn ctermbg=235
		highlight ColorColumn ctermbg=235
		
		if $TMUX != ''
			au FocusGained * highlight LineNr ctermbg=235
			au FocusGained * highlight CursorColumn ctermbg=235
			au FocusGained * highlight ColorColumn ctermbg=235

			au FocusLost * highlight LineNr ctermbg=234
			au FocusLost * highlight CursorColumn ctermbg=233
			au FocusLost * highlight ColorColumn ctermbg=233
			
			if $__CFBundleIdentifier == 'io.alacritty'
				highlight Normal ctermbg=NONE
			end
		end

		" highlight SignColumn guibg=245
	endif


" -----------------------------------------------------------------------------
" Bindings:
" -----------------------------------------------------------------------------

	" Allow 'i' in visual mode to delete everything selected and enter insert
	" mode.
	vnoremap i d

	" SHIFT+TAB: Un-indent.
	nnoremap <S-Tab> <Nop>
	inoremap <S-Tab> <C-d>

	" g+LEFT/RIGHT: Prev/next hunk.
	nnoremap g<Right> :GitGutterNextHunk<CR>
	nnoremap g<Left> :GitGutterPrevHunk<CR>
	nnoremap <S-Up> :GitGutterPrevHunk<CR>
	nnoremap <S-Down> :GitGutterNextHunk<CR>

	" SHIFT+H: Toggle git change highlighting.
	nnoremap H :GitGutterLineHighlightsToggle<CR>

" -----------------------------------------------------------------------------
" Integrations:
" -----------------------------------------------------------------------------

	" Ranger instead of netrw.
	let g:bclose_no_plugin_maps = 1
	let g:ranger_map_keys = 0
	let g:ranger_replace_netrw = 1

	" Alacritty->Tmux: Cmd+O to open Ranger.
	nnoremap <M-C-F12>o <C-c>:call OpenIntegration()<CR>
	cnoremap <M-C-F12>o <Esc>:call OpenIntegration()<CR>
	inoremap <M-C-F12>o <C-o>:call OpenIntegration()<CR>
	function OpenIntegration()
		if &modified
			echohl WarningMsg
			echo "No write since last change"
			echohl Normal
			return
		end

		echo "Open file with Ranger."
		Ranger
	endfunction

	" Copy using OSC52 on non-Mac systems (or SSH).
	" Either register '*' or '+' will copy to the clipboard.
	if !has('macunix') || $SSH_CONNECTION != ""
		autocmd TextYankPost * if v:event.operator is 'y' && (v:event.regname is '+' || v:event.regname is '*') | execute 'OSCYankReg +' | endif
	end


" -----------------------------------------------------------------------------
" iTerm2 Touch Bar:
" -----------------------------------------------------------------------------

	function TouchBar()
		TouchBarLabel F3 " "
		TouchBarLabel F4 " "
		TouchBarLabel F5 "Copy"
		TouchBarLabel F6 "Save"
		TouchBarLabel F7 " "
		TouchBarLabel F8 "Undo"
		TouchBarLabel F9 "Redo"
		TouchBarLabel F10 " "

		call s:Rebind()
		if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
			TouchBarLabel F1 "???"
			TouchBarLabel F2 "???"
		else
			TouchBarLabel F1 "<<"
			TouchBarLabel F2 ">>"
		endif
	endfunction

	" Touch Bar key bindings.
	function s:Rebind()
		if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
			" If there's multiple buffers, use F1 and F2 to swap buffers.
			noremap <F1> :bprev<CR>
			noremap <F2> :bnext<CR>
		else
			" If there's only one buffer, use F1 and F2 to jump between merge conflicts.
			noremap <F1> <Nop>
			noremap <F2> <Nop>
			nnoremap <F1> :ConflictMarkerPrevHunk<CR>
			nnoremap <F2> :ConflictMarkerNextHunk<CR>
			inoremap <F1> <c-O>:ConflictMarkerPrevHunk<CR>
			inoremap <F2> <c-O>:ConflictMarkerNextHunk<CR>
		endif
	endfunction

	call s:Rebind()
	noremap <F4> <Nop>
	noremap <F5> <Nop>
	vnoremap <F5> "*y
	noremap <F6> <c-C>:w<CR>
	inoremap <F6> <c-O>:w<CR>
	noremap <F7> <Nop>

	" F8: Undo
		noremap <F8> <Nop>
		nnoremap <F8> u
		inoremap <F8> <Esc>ui

	" F9: Redo
		noremap <F9> <Nop>
		nnoremap <F9> <C-r>
		inoremap <F9> <Esc><C-r>i

	noremap <F10> <Nop>

