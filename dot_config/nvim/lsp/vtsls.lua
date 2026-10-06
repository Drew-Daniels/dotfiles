local vls_bin = vim.fn.exepath("vue-language-server")
local vls_dir = vls_bin:gsub("/bin/vue%-language%-server", "/lib/node_modules/@vue/language-server")

return {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vls_dir,
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}
