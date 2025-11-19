require("config.lazy")

local function read_json_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		print("Could not open file: " .. file_path)
		return nil
	end

	local content = file:read("*a")
	file:close()
	return content
end

local function parse_json_using_jq(file_path, jq_filter)
	local command = string.format("jq '%s' %s", jq_filter, file_path)
	local handle = io.popen(command) -- Execute the jq command
	local result = handle:read("*a")
	handle:close()
	return result
end

if vim.loop.os_uname().sysname == "Linux" then
	local json_file_path = "$XDG_STATE_HOME/theme-toggle/state.json"
	local expanded_json_file_path = vim.fn.expand(json_file_path)
	local jq_filter = ".theme"
	local json_content = read_json_file(expanded_json_file_path)

	if json_content then
		local parsed_content = parse_json_using_jq(expanded_json_file_path, jq_filter)
		local fmt_content = string.gsub(parsed_content, '"', ""):match("^%s*(.-)%s*$")
		if fmt_content == "light" then
			-- vim.cmd("colorscheme catppuccin")
			-- vim.cmd("colorscheme onenord-light")
			vim.cmd("colorscheme zenbones")
			vim.cmd("set bg=light")
		else
			vim.cmd("colorscheme gruvbox")
			vim.cmd("set bg=dark")
		end
	else
		vim.cmd("colorscheme gruvbox")
	end
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
	vim.cmd("e ~/projects/work_notes/su/2025/" .. date .. ".norg")
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

-- NOTE: References logic shown here: https://neovim.io/doc/user/lsp.html#lsp-attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tinymist", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local bufnr = assert(args.buf)

		vim.keymap.set("n", "<leader>tp", function()
			client:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { vim.api.nvim_buf_get_name(0) },
			}, { bufnr = bufnr })
		end, { desc = "[T]inymist [P]in", noremap = true })

		vim.keymap.set("n", "<leader>tu", function()
			client:exec_cmd({
				title = "unpin",
				command = "tinymist.pinMain",
				arguments = { vim.v.null },
			}, { bufnr = bufnr })
		end, { desc = "[T]inymist [U]npin", noremap = true })
	end,
})

-- ── GENERAL ─────────────────────────────────────────────────────────

-- Deactivate LSP logging except only when necessary, since this file can become huge overtime when permanently left on
-- vim.lsp.log.set_level("debug")
vim.lsp.log.set_level("error")
-- vim.lsp.log.set_level("off")

vim.keymap.set("n", "n", "nzz", { silent = true, desc = "Search Next" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Search Prev" })
vim.keymap.set("i", "<C-b>", "<CR><ESC>kA<CR>", { silent = true, desc = "Insert blank line" })

local function yank_buffer_abs_file_path()
	local full_path = vim.api.nvim_buf_get_name(0)
	vim.fn.setreg("+", full_path)
	vim.notify("Copied Buffer File Path to Clipboard: " .. vim.fn.getreg("+"), vim.log.levels.INFO)
end

local function yank_buffer_rel_file_path()
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

vim.keymap.set("n", "<leader>Ya", yank_buffer_abs_file_path, {
	silent = true,
	desc = "Yank Absolute Buffer File Path to Clipboard",
})

vim.keymap.set("n", "<leader>Yr", yank_buffer_rel_file_path, {
	silent = true,
	desc = "Yank Relative Buffer File Path to Clipboard",
})

vim.keymap.set("n", "<leader>Yf", yank_buffer_file_name, {
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
		mdc = "markdown",
	},
})

vim.filetype.add({
	extension = {
		jira = "jira",
	},
})

vim.filetype.add({
	extension = {
		["swcrc"] = "json",
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
	pattern = {
		["*.yaml.gotmpl"] = "yaml",
		[".*/templates/.*%.ya?ml"] = "helm",
		[".*/templates/NOTES.txt"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
	},
})

-- Disable Tree-sitter highlighting for tenant.yaml, since '@' characters are considered reserved characters, and break the syntax highlighting logic
-- Also disable yaml-language-server since it doesn't understand this character
-- See: https://github.com/auth0/auth0-deploy-cli/issues/732#issue-1573140744
vim.api.nvim_create_autocmd("LspAttach", {
	pattern = "tenant.yaml",
	callback = function()
		vim.cmd("TSBufDisable highlight")
		-- Disable Tree-sitter highlighting for tenant.yaml, since '@' characters are considered reserved characters, and break the syntax highlighting logic
		-- Also disable yaml-language-server since it doesn't understand this character
		-- See: https://github.com/auth0/auth0-deploy-cli/issues/732#issue-1573140744
		vim.cmd("LspStop yamlls")
	end,
})
