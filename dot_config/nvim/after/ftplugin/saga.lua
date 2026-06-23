vim.treesitter.language.add("saga", {
	path = vim.fn.expand("~/projects/towncrier-v2/tree-sitter-saga/saga.so"),
})
vim.treesitter.start(0, "saga")
-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.lsp.start({
	name = "saga",
	cmd = { vim.fn.expand("~/projects/towncrier-v2/towncrier"), "saga", "lsp" },
	root_dir = vim.fs.dirname(vim.fs.find("saga", { upward = true, path = vim.fn.expand("%:p:h") })[1]),
})
