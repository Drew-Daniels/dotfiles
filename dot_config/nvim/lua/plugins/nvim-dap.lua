return {
	"mfussenegger/nvim-dap",
	config = function()
		-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#ccrust-via-codelldb
		-- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		local dap = require("dap")
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
				runtimeExecutable = "deno",
				runtimeArgs = {
					"run",
					"--inspect-wait",
					"--allow-all",
				},
				program = "${file}",
				cwd = "${workspaceFolder}",
				attachSimplePort = 9229,
			},
		}
	end,
}
