require('luaConfig.opts_and_keys')
require("lze").register_handlers(require('nixCatsUtils.lzUtils').for_cat)
require('lze').register_handlers(require('lzextras').lsp)
require("luaConfig.plugins")
require("luaConfig.LSPs")

if nixCats('lint') then
  require('luaConfig.lint')
end
if nixCats('format') then
  require('luaConfig.format')
end
