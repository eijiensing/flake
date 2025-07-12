return {
  {
    "rustaceanvim",
    for_cat = 'rust',

    -- rustaceanvim lazy-loads on filetype itself, so this is "lazily-n't" loaded
    event = "DeferredUIEnter",

    after = function(plugin)
      vim.g.rustaceanvim = {
        on_attach = require('luaConfig.LSPs.on_attach'),
        -- function(client, bufnr)
        --
        --   vim.keymap.set(
        --     "n",
        --     "<leader>ca",
        --     function ()
        --       vim.lsp.('codeAction')
        --     end,
        --     { silent = true, buffer = bufnr }
        --   )
        --   vim.keymap.set(
        --     "n",
        --     "K",
        --     function ()
        --       vim.cmd.RustLsp({'hover', 'actions'})
        --     end,
        --     { silent = true, buffer = bufnr }
        --   )
        -- end,
      }
    end,
  },
}
