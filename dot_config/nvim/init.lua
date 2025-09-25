require("config.lazy")

if vim.loop.os_uname().sysname == "Linux" then
	-- can't rely on dark-notify to work on linux
	vim.cmd("colorscheme gruvbox")
end

vim.api.nvim_create_user_command("SU", function(opts)
	local date = os.date("%Y-%m-%d")
	if opts.fargs[1] == "yd" then
		date = os.date("%Y-%m-%d", os.time() - 86400)
	elseif opts.fargs[1] == "td" then
		date = os.date("%Y-%m-%d")
	elseif opts.fargs[1] == "tm" and os.date("%w") == "5" then
		-- If td is Friday, then next business day is Monday
		date = os.date("%Y-%m-%d", os.time() + 86400 * 3)
	elseif opts.fargs[1] == "tm" then
		date = os.date("%Y-%m-%d", os.time() + 86400)
	else
		print("Invalid date")
		return
	end
	vim.cmd("e ~/projects/work_notes/su/2024/" .. date .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("Project", function(opts)
	local name = opts.fargs[1]
	if type(name) ~= "string" then
		print("Invalid name")
		return
	end
	vim.cmd("e ~/projects/work_notes/projects/" .. name .. ".norg")
end, { nargs = "*" })

-- TODO: De-hardcode paths here
vim.cmd([[
  augroup neorg_cmds
    autocmd BufNewFile ~/projects/work_notes/su/**/*.norg 0read ~/.config/nvim/norg/templates/standup_template.norg
    autocmd FileType norg setlocal conceallevel=3
    " Figure out how to stop folds from getting created on buffers created after first entering into a .norg buffer
    autocmd BufWritePost ~/projects/work_notes/su/**/*.norg silent !git -C ~/projects/work_notes/su/ add . && git -C ~/projects/work_notes/su/ commit -m "Update work notes" && git -C ~/projects/work_notes/su/ push
    autocmd BufWritePost ~/projects/work_notes/projects/*.norg silent !git -C ~/projects/work_notes/projects/ add . && git -C ~/projects/work_notes/projects/ commit -m "Update work notes" && git -C ~/projects/work_notes/projects/ push
  augroup END
]])

vim.api.nvim_create_user_command("JsonSort", function()
	local filename = vim.fn.expand("%:p")
	vim.fn.system("jsonsort " .. filename)
	vim.cmd("edit")
end, {})

vim.api.nvim_create_augroup("filetype_html", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.html.en" },
	command = "set filetype=html",
	group = "filetype_html",
})

vim.api.nvim_create_augroup("filetype_map", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.js.map" },
	command = "set filetype=json",
	group = "filetype_map",
})

-- ── GENERAL ─────────────────────────────────────────────────────────

-- Deactivate LSP logging except only when necessary, since this file can become huge overtime when permanently left on
-- vim.lsp.set_log_level("debug")
vim.lsp.set_log_level("error")
-- vim.lsp.set_log_level("off")

vim.keymap.set("n", "n", "nzz", { silent = true, desc = "Search Next" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Search Prev" })
vim.keymap.set("i", "<C-b>", "<CR><ESC>kA<CR>", { silent = true, desc = "Insert blank line" })

local function yank_buffer_file_path()
	local full_path = vim.api.nvim_buf_get_name(0)
	local relative_path = vim.fn.fnamemodify(full_path, ":.")
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied Buffer File Path to Clipboard: " .. vim.fn.getreg("+"), vim.log.levels.INFO)
end

-- TODO: Dedupe shared steps
local function yank_buffer_file_name()
	local full_path = vim.api.nvim_buf_get_name(0)
	local file_name = vim.fn.fnamemodify(full_path, ":t")
	vim.fn.setreg("+", file_name)
	vim.notify("Copied Buffer File Name to Clipboard: " .. vim.fn.getreg("+"), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>Yp", yank_buffer_file_path, {
	silent = true,
	desc = "Yank Buffer File Path to Clipboard",
})

vim.keymap.set("n", "<leader>Yn", yank_buffer_file_name, {
	silent = true,
	desc = "Yank Buffer File Name to Clipboard",
})

vim.keymap.set("i", "<C-o>", "<CR><ESC>I")

-- Allows for exiting the integrated neovim terminal using a more memorable key sequence
-- https://vi.stackexchange.com/a/4922/48860
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])
-- do not open folds when moving cursor
vim.diagnostic.config({ virtual_text = { source = true } })

vim.filetype.add({
	filename = {
		["Brewfile"] = "brewfile",
	},
})

vim.filetype.add({
	extension = {
		jira = "jira",
	},
})

vim.filetype.add({
	extension = {
		snapshot = "javascript",
	},
})

-- vacuum
vim.filetype.add({
	pattern = {
		["openapi.*%.ya?ml"] = "yaml.openapi",
		["openapi.*%.json"] = "json.openapi",
	},
})

-- gitlab-ci-ls
vim.filetype.add({
	pattern = {
		["%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
		["ops%-tools/**/*%.ya?ml"] = "yaml.gitlab",
	},
})

-- tree-sitter-go-template
vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
	},
	-- pattern = {
	-- 	["*.yaml.gotmpl"] = "yaml",
	-- 	-- [".*/templates/.*%.ya?ml"] = "helm",
	-- 	-- ["helmfile.*%.ya?ml"] = "helm",
	-- },
})
