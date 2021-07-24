" dotfiles | Copyright (C) 2021 eth-p
" Repository: https://github.com/eth-p/dotfiles

filetype plugin on
call plug#begin()
	Plug 'itchyny/lightline.vim'
	Plug 'tpope/vim-surround'

	" Git stuff.
	Plug 'rhysd/conflict-marker.vim'
	Plug 'airblade/vim-gitgutter'

	" Terminal stuff.
	" Plug 'eth-p/vim-it2-touchbar'

	" Languages.
	Plug 'dag/vim-fish'
	Plug 'fatih/vim-go'
	Plug 'cespare/vim-toml'
	Plug 'digitaltoad/vim-pug'

	" Themes.
	Plug 'crusoexia/vim-monokai'  " Dark theme.
	Plug 'chiendo97/intellij.vim' " Light theme.
call plug#end()


" -----------------------------------------------------------------------------
" General:
" -----------------------------------------------------------------------------

	set mouse=a             " Enable mouse support.
	set whichwrap+=<,>,[,]  " Allow arrow keys to wrap lines.

	" Enable syntax.
	syntax enable
	filetype plugin indent on

	" Enable better status line with 'lightline'.
	set laststatus=2
	set noshowmode
	let g:lightline = {
	\	'active': {
	\		'left': [[ 'mode', 'paste' ], ['readonly', 'filename', 'modified'], [ 'git_status' ]]
	\	},
	\	'component_function': {
	\		'git_status': 'LLCustom_GitStatus'
	\	},
	\	'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\	'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
	\}

	function! LLCustom_GitStatus()
		let [a,m,r] = GitGutterGetHunkSummary()
		return printf('+%d ~%d -%d', a, m, r)
	endfunction

	" Enable title.
	set title
	set titlestring=Edit:\ %F

	" Enable sidebar.
	set updatetime=0    " Immediately show the git sidebar.
	set number          " Enable line numbers.
	set numberwidth=5   " Set the line number width.

	if has('nvim')
		autocmd User GitGutter GitGutterLineNrHighlightsEnable
	end

	" Adjust tabs.
	set tabstop=4
	set shiftwidth=4

	autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2

	" Enable spell check for Markdown.
	autocmd FileType markdown setlocal spell spelllang=en_us

	" Highlight the 80th and 120th columns.
	set colorcolumn=80,120

" -----------------------------------------------------------------------------
" Theme:
" -----------------------------------------------------------------------------

	if $TERM_THEME == "light"
		colorscheme intellij
		let g:lightline['colorscheme'] = 'one'
	else
		colorscheme monokai
		let g:lightline['colorscheme'] = 'powerline'

		if $__CFBundleIdentifier == 'io.alacritty'
			highlight Normal ctermbg=NONE
		end

		" highlight Normal ctermbg=NONE
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
			TouchBarLabel F1 "←"
			TouchBarLabel F2 "→"
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

