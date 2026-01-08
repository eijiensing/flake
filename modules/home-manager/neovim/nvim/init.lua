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
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

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

vim.lsp.enable({ "lua_ls", "vtsls", "rust_analyzer", "qmlls", "nixd" })

-- colors
vim.g.gruvbox_material_background = "hard"
vim.cmd.colorscheme("gruvbox-material")
vim.cmd(":hi statusline guibg=NONE")
