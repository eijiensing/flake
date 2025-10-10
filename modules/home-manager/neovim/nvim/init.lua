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
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup()
require("mini.pick").setup()
require("oil").setup({ keymaps = { ["\\"] = "actions.close" } })


map("n", "\\", ":Oil<CR>")
map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>g", ":Pick grep_live<CR>")
map("n", "grf", vim.lsp.buf.format)
map("n", "grd", vim.diagnostic.open_float)
map("n", "gd", vim.lsp.buf.definition)
map("v", ">", ">gv")
map("v", "<", "<gv")

vim.lsp.enable({ "lua_ls", "vtsls", "rust_analyzer", "qmlls" })

-- colors
vim.g.gruvbox_material_background = "hard"
vim.cmd.colorscheme("gruvbox-material")
vim.cmd(":hi statusline guibg=NONE")
