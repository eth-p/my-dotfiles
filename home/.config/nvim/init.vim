" my-dotfiles | Copyright (C) 2021 eth-p
" Repository: https://github.com/eth-p/my-dotfiles

filetype plugin on
call plug#begin()
	Plug 'itchyny/lightline.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-sleuth'
	Plug 'ojroques/vim-oscyank', {'branch': 'main'}

	" LSP.
	Plug 'dense-analysis/ale'

	" Git stuff.
	Plug 'rhysd/conflict-marker.vim'
	Plug 'airblade/vim-gitgutter'

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

	" Configure ALE for better messages.
	let g:ale_floating_preview = 1
	let g:ale_floating_window_border = [
	\   "\u2506", "\u2504", 
	\   "\u250C", "\u2510", "\u2518", "\u2514",
	\   "\u2506", "\u2504" 
	\]

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

		let g:focus_text   = 'ctermbg=NONE'
		let g:focus_number = 'ctermbg=235 ctermfg=243'
		let g:focus_guide  = 'ctermbg=235'

		let g:lost_text    = 'ctermbg=NONE'
		let g:lost_number  = 'ctermbg=234 ctermfg=240'
		let g:lost_guide   = 'ctermbg=NONE'

		"if $TMUX != ''
		"endif

		execute "au FocusGained * highlight Normal ".g:focus_text
		execute "au FocusGained * highlight LineNr ".g:focus_number
		execute "au FocusGained * highlight CursorColumn ".g:focus_guide
		execute "au FocusGained * highlight ColorColumn ".g:focus_guide

		execute "au FocusLost * highlight Normal ".g:lost_text
		execute "au FocusLost * highlight LineNr ".g:lost_number
		execute "au FocusLost * highlight CursorColumn ".g:lost_guide
		execute "au FocusLost * highlight ColorColumn ".g:lost_guide

		execute "highlight Normal ".g:focus_text
		execute "highlight LineNr ".g:focus_number
		execute "highlight CursorColumn ".g:focus_guide
		execute "highlight ColorColumn ".g:focus_guide

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

	" ALT+Slash: Show the ALE warning at the line.
	nnoremap <silent> <A-/> :ALEDetail<CR>
	inoremap <silent> <A-/> <C-c> :ALEDetail<CR>

	" RETURN: Clear search highlighting in normal mode.
	nnoremap <silent> <CR> :noh<CR><CR>

" -----------------------------------------------------------------------------
" Integrations:
" -----------------------------------------------------------------------------

	" Create a command that can bind integration chords.
	" This is needed because vim and nvim handle the C-S-F12 prefix
	" differently.
	command! -nargs=+ Integration execute printf('%sremap %s%s %s',
		\ split(<q-args>, ' ')[0],
		\ has('nvim') ? '<'.'F48'.'>' : '<'.'C-S-F12'.'>',
		\ split(<q-args>, ' ')[1],
		\ join(split(<q-args>, ' ')[2:], ' '))

	" Ranger instead of netrw.
	let g:bclose_no_plugin_maps = 1
	let g:ranger_map_keys = 0
	let g:ranger_replace_netrw = 1

	" Alacritty->Tmux: Cmd+O to open Ranger.
	Integration nno o <C-c>:call OpenIntegration()<CR>
	Integration cno o <Esc>:call OpenIntegration()<CR>
	Integration ino o <C-o>:call OpenIntegration()<CR>
	function OpenIntegration()
		if &modified
			echohl WarningMsg
			echo "No write since last change"
			echohl Normal
			return
		end

		echo "Open file with Ranger."
		execute 'Ranger'
	endfunction

	" Copy using OSC52 on non-Mac systems (or SSH).
	" Either register '*' or '+' will copy to the clipboard.
	if !has('macunix') || $SSH_CONNECTION != ""
		autocmd TextYankPost * if v:event.operator is 'y' && (v:event.regname is '+' || v:event.regname is '*') | execute 'OSCYankReg +' | endif
	end

	" Integration: copy
	Integration no c <Nop>
	Integration ino c <Nop>
	Integration vno c "*y

	" Integration: save
	Integration no s <c-C>:w<CR>
	Integration ino s <c-O>:w<CR>

	" Integration: find
	Integration no f <c-C>/
	Integration ino f <c-C>/

