-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")

--============================================================================--
--=== Functions ===--

local colorschemes = {
	-- [colorscheme_name] = {
	--    config = function(self),
	--    lualine = "theme-name",
	--    overrides = {
	--       general = {
	--           Normal = {...},
	--           ...
	--       }
	--    }
	-- }
}

local function get()
	return colorschemes[vim.g.colors_name] or {}
end

local function reapply()
	local theme = get()
	local overrides = theme.overrides or {}

	if theme.config ~= nil then
		theme.config(theme)
	end

	-- Change the colorscheme.
	vim.cmd.colorscheme(vim.g.colors_name)

	-- Apply the general overrides.
	if overrides.general ~= nil then
		for k, v in pairs(overrides.general) do
			vim.api.nvim_set_hl(0, k, v)
		end
	end
end

local function register(spec)
	colorschemes[spec.colorscheme] = spec
end

--============================================================================--
--=== Autocommands ===--

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		reapply()
	end,
})

--============================================================================--
--=== Exports ===--

return {
	get = get, -- returns the current theme
	reapply = reapply,
	register = register,
}
