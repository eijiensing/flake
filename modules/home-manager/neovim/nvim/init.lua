vim.cmd([[set mouse=]])
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
	severity_sort = true
})

local map = vim.keymap.set
vim.g.mapleader = " "

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	-- themes
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/edeneast/nightfox.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/dchinmay2/alabaster.nvim" },
	{ src = "https://github.com/junegunn/seoul256.vim" },

})

-- require'nvim-treesitter'.install { 'all' }

require("oil").setup({ keymaps = { ["\\"] = "actions.close" } })

require("fzf-lua").setup({
	grep = {
		rg_opts = table.concat({
			"--column",
			"--line-number",
			"--no-heading",
			"--color=always",
			"--smart-case",
			"--hidden",
		}, " "),
	},
})

map("v", ">", ">gv")
map("v", "<", "<gv")
map("n", "\\", ":Oil<CR>")
map("n", "<leader>f", ":FzfLua files<CR>")
map("n", "<leader>g", ":FzfLua grep_project<CR>")
map("n", "grf", vim.lsp.buf.format)
map("n", "grd", vim.diagnostic.open_float)
map("n", "gd", ":FzfLua lsp_definitions<CR>")
map("n", "grr", ":FzfLua lsp_references<CR>")

vim.lsp.enable({ "gopls", "zls", "lua_ls", "vtsls", "rust_analyzer", "qmlls", "nixd", "csharp-ls" })

-- colors
vim.g.gruvbox_material_background = "hard"

local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/nvim.lua")
if vim.fn.filereadable(theme_file) == 1 then
	local c = dofile(theme_file)

	local function set_hl(group, opts)
		for key, value in pairs(opts) do
			if type(value) == "string" and value:match("^%x+$") then
				opts[key] = "#" .. value
			end
		end
		vim.api.nvim_set_hl(0, group, opts)
	end

	vim.o.background = c.mode == "light" and "light" or "dark"
	vim.cmd.colorscheme("gruvbox-material")

	set_hl("Normal", { bg = c.background, fg = c.onSurface })
	set_hl("NormalFloat", { bg = c.surfaceContainer, fg = c.onSurface })
	set_hl("Comment", { fg = c.onSurfaceVariant, italic = true })
	set_hl("Conceal", { fg = c.onSurfaceVariant })
	set_hl("LineNr", { fg = c.onSurfaceVariant })
	set_hl("CursorLineNr", { fg = c.primary })
	set_hl("CursorLine", { bg = c.surfaceContainerLow })
	set_hl("Cursor", { bg = c.onSurface, fg = c.background })
	set_hl("Search", { bg = c.primary, fg = c.onPrimary })
	set_hl("CurSearch", { bg = c.tertiary, fg = c.onTertiary })
	set_hl("Visual", { bg = c.primaryContainer, fg = c.onPrimaryContainer })
	set_hl("StatusLine", { bg = c.surfaceContainer, fg = c.onSurface })
	set_hl("StatusLineNC", { bg = c.surface, fg = c.onSurfaceVariant })
	set_hl("WinSeparator", { fg = c.surfaceContainerHigh })
	set_hl("VertSplit", { fg = c.surfaceContainerHigh })
	set_hl("SignColumn", { bg = c.background, fg = c.onSurfaceVariant })
	set_hl("Pmenu", { bg = c.surfaceContainer, fg = c.onSurface })
	set_hl("PmenuSel", { bg = c.primary, fg = c.onPrimary })
	set_hl("Error", { fg = c.error })
	set_hl("ErrorMsg", { fg = c.error })
	set_hl("WarningMsg", { fg = c.tertiary })
	set_hl("MatchParen", { bg = c.primaryContainer, fg = c.onPrimaryContainer })
	set_hl("Title", { fg = c.primary })
	set_hl("Function", { fg = c.primary })
	set_hl("Keyword", { fg = c.primary })
	set_hl("Statement", { fg = c.primary })
	set_hl("String", { fg = c.tertiary })
	set_hl("Character", { fg = c.tertiary })
	set_hl("Type", { fg = c.tertiary })
	set_hl("Constant", { fg = c.secondary })
	set_hl("Identifier", { fg = c.onSurface })
	set_hl("DiagnosticError", { fg = c.error })
	set_hl("DiagnosticWarn", { fg = c.tertiary })
	set_hl("DiagnosticInfo", { fg = c.primary })
	set_hl("DiagnosticHint", { fg = c.secondary })
	set_hl("DiagnosticVirtualTextError", { fg = c.error })
	set_hl("DiagnosticVirtualTextWarn", { fg = c.tertiary })
	set_hl("DiagnosticVirtualTextInfo", { fg = c.primary })
	set_hl("DiagnosticVirtualTextHint", { fg = c.secondary })
else
	vim.cmd.colorscheme("gruvbox-material")
end

vim.cmd(":hi statusline guibg=NONE")
