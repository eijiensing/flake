return {
  {
    "rustaceanvim",
    for_cat = 'rust',

    -- rustaceanvim lazy-loads on filetype itself, so this is "lazily-n't" loaded
    event = "DeferredUIEnter",

    after = function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set(
        "n",
        "<leader>ca",
        function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end,
        { silent = true, buffer = bufnr }
      )
    end,
  },
}
