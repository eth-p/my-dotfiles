-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================

-- DO NOT ALLOW REQUIRING MODULES FROM THE WORKING DIRECTORY!
package.path = package.path:gsub("./%?.lua;", "")
package.cpath = package.cpath:gsub("./%?.so;", "")

--============================================================================--
--=== Load Modules ===--
local commands = require("eth-p.commands")
local opts = require("eth-p.opts")
local whitespace = require("eth-p.whitespace")

--============================================================================--
--=== Neovim Config ===--

function InitConfig(opts)
	--
	-- Configure Keymap
	--

	vim.g.mapleader = "\\"
	vim.g.maplocalleader = "\\"

	--
	-- Configure Gutter
	--

	vim.o.number = opts.gutter.numbers.enabled -- Line numbers
	vim.o.numberwidth = opts.gutter.numbers.width --  -> Width
	vim.o.relativenumber = true --  -> Relative to cursor
	vim.o.nu = false --  -> Without absolute
	vim.o.cursorline = true -- Enable cursor line formatting
	vim.o.cursorlineopt = "number" --  -> Only the line number
	vim.o.signcolumn = "auto" -- Enable sign column

	if opts.gutter.numbers.enabled then
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*",
			callback = commands.HideSidebar,
		})
	end

	--
	-- Configure Editor
	--

	vim.o.tabstop = 4 -- Tab width
	vim.o.shiftwidth = 4 --   For shift as well.

	if opts.editor.fold.enabled then
		local foldwidth = "" .. opts.gutter.fold.width
		if not opts.gutter.fold.enabled then
			foldwidth = "0"
		end

		vim.o.foldenable = true -- Folding
		vim.o.foldcolumn = foldwidth --  -> Width in gutter
		vim.o.foldlevel = 99 -- Needed for `ufo` plugin
		vim.o.foldlevelstart = 99 -- Needed for `ufo` plugin
	end

	-- Show whitespace chars.
	whitespace.setup_auto_list(opts.editor.whitespace.show_on_filetypes)

	if opts.editor.whitespace.show_always == true then
		vim.o.list = true
	end

	if opts.editor.whitespace.chars ~= nil then
		whitespace.set_listchars(vim.o, opts.editor.whitespace.chars)
	end

	--
	-- Configure Clipboard
	--

	if vim.env.WSL_INTEROP ~= nil and vim.env.SSH_TTY == nil then
		vim.g.clipboard = {
			name = "WSL",
			copy = {
				["+"] = "clip.exe",
				["*"] = "clip.exe",
			},
			paste = {
				["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			},
		}
	end
end

function InitCommands(opts)
	local prefix = opts.commands.prefix
	local new_command = vim.api.nvim_create_user_command

	new_command(prefix .. "ToggleSidebar", commands.ToggleSidebar, {})
	new_command(
		prefix .. "ToggleVisualWhitespace",
		commands.ToggleVisualWhitespace,
		{}
	)
	new_command(
		prefix .. "ToggleCenteredCursor",
		commands.ToggleCenteredCursor,
		{}
	)
	new_command(prefix .. "HideSidebar", commands.HideSidebar, {})
	new_command(prefix .. "ShowSidebar", commands.ShowSidebar, {})
end

function InitKeymaps(opts)
	if opts.keymap.preserve then
		return
	end

	local set = vim.keymap.set

	-- Remove neovim builtins
	vim.keymap.del("n", "<C-W>d")
	vim.keymap.del("n", "<C-W><C-D>")

	-- Window management.
	set("n", "<C-W>s", "<Cmd>vsplit<CR><C-W>w", {
		desc = "New vertical split",
	})

	set("n", "<C-W>S", "<Cmd>split<CR><C-W>w", {
		desc = "New horizontal split",
	})

	set(
		"n",
		"<C-W>n",
		"<Cmd>vsplit<CR><C-W>w<Cmd>enew<CR>",
		{ desc = "New vertical window" }
	)

	set(
		"n",
		"<C-W>N",
		"<Cmd>split<CR><C-W>w<Cmd>enew<CR>",
		{ desc = "New horizontal window" }
	)

	set("n", "<C-W>c", "<Cmd>close<CR>", { desc = "Close window" })

	set("n", "<C-W>!c", "<Cmd>only<CR>", { desc = "Close other windows" })
end

--============================================================================--
--=== Plugin Manager Initialization ===--

function InitPlugins(opts, extra_plugins)
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system {
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			lazyrepo,
			lazypath,
		}
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup {
		spec = {
			{ import = "eth-p/plugins" },
			extra_plugins,
		},
		install = { colorscheme = { opts.ui.colorscheme } },
		checker = { enabled = true },
		change_detection = { notify = false },
	}
end

--============================================================================--
--=== Exports ===--

-- Return a function for setting up my config.
return function(spec)
	if spec.opts ~= nil then
		opts(spec.opts) -- update options singleton
	end

	vim.g.colors_name = opts.ui.colorscheme
	InitConfig(opts)
	InitKeymaps(opts)
	InitPlugins(opts, spec.plugins)
	InitCommands(opts)

	-- Apply the colorscheme.
	vim.cmd.colorscheme(opts.ui.colorscheme)

	if spec.ready ~= nil then
		spec.ready(spec)
	end
end
