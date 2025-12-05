vim.g.deepl_api_auth_key = os.getenv("DEEPL_API_AUTH_KEY")

return {
	"uga-rosa/translate.nvim",
	opts = {
		default = {
      -- NOTE: To replace original text
			-- output = "replace",
      output = "floating"
		},
	},
}
