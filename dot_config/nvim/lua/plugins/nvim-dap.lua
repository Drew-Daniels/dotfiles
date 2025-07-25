return {
	"mfussenegger/nvim-dap",
	config = function()
		-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#ccrust-via-codelldb
		-- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		local dap = require("dap")
		-- NOTE: Default "INFO" - :h dap.set_log_level()
		-- dap.set_log_level("DEBUG")
		-- ADAPTERS
		dap.adapters.codelldb = {
			type = "executable",
			command = "codelldb",
		}
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { os.getenv("HOME") .. "/.config/vscode-js-debug/src/dapDebugServer.js", "${port}" },
			},
		}
		-- NOTE: chrome has to be started with a remote debugging port google-chrome-stable --remote-debugging-port=9222
		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			args = { os.getenv("HOME") .. "/projects/vscode-chrome-debug/out/src/chromeDebug.js" },
		}
		-- CONFIGURATIONS
		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		-- Reuse
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp
		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}
		dap.configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}
		-- dap.configurations.javascript = {
		-- 	{
		-- 		type = "chrome",
		-- 		request = "attach",
		-- 		name = "Launch File",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		port = 9222,
		-- 		webRoot = "${workspaceFolder}",
		-- 	},
		-- }
		-- dap.configurations.typescript = {
		-- 	{
		-- 		type = "chrome",
		-- 		request = "attach",
		-- 		name = "Launch File",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		port = 9222,
		-- 		webRoot = "${workspaceFolder}",
		-- 	},
		-- }
	end,
}
