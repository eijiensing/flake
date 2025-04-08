return {
  {
    "stevearc/oil.nvim",
    opts = {
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["\\"] = { "actions.close", mode = "n" },
      },
    },
  },
}
