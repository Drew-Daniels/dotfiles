vim.treesitter.language.add("saga", {
  path = vim.fn.expand("~/projects/towncrier-v2/tree-sitter-saga/saga.so"),
})
vim.treesitter.start(0, "saga")
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
