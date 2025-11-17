-- Overrides the setlocal tabstop setting made by /opt/homebrew/Cellar/neovim/0.11.5/share/nvim/runtime/ftplugin/markdown.vim
-- Or, wherever this file is located
-- TODO: Remove overrides that are not necessary
-- autoindent new lines
vim.bo.autoindent = true
-- expands tabs into spaces
vim.bo.expandtab = true
-- number of spaces to use for each tab
vim.bo.tabstop = 2
-- number of spaces to use when indenting
vim.bo.shiftwidth = 2
-- number of spaces to use for (auto)indent step
vim.bo.softtabstop = 2
