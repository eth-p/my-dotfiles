-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
-- DO NOT EDIT! This file is generated by home-manager.
-- To customize, create a `config.lua` file:
--
--     return {
--         opts = {},
--         ready = function()
--             -- called after lazy.nvim
--         end,
--     }
--
-- =============================================================================

-- DO NOT ALLOW REQUIRING MODULES FROM THE WORKING DIRECTORY!
package.path = package.path:gsub("./%?.lua;", "")
package.cpath = package.cpath:gsub("./%?.so;", "")

--============================================================================--
--=== Config Loading ===--

local config = { opts = {} }
local config_home = vim.fn.stdpath("config")

-- Load home-manager managed config.
config = vim.tbl_deep_extend(
	"force",
	config,
	dofile(config_home .. "/managed-by-nix.lua")
)

-- Load mutable config from config.lua
if vim.uv.fs_stat(config_home .. "/config.lua") then
	config = vim.tbl_deep_extend(
		"force",
		config,
		dofile(config_home .. "/config.lua") or {}
	)
end

--============================================================================--
--=== Initialize ===--

require("eth-p")(config)
