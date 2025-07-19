return {
  {
    "rustaceanvim",
    for_cat = 'rust',

    -- rustaceanvim lazy-loads on filetype itself, so this is "lazily-n't" loaded
    event = "DeferredUIEnter",

    keys = {
      {"<leader>ca", "<cmd>RustLsp codeAction<CR>", mode = {"n"}, noremap = true, desc = "Rust code actions"},
    },
  },
}
