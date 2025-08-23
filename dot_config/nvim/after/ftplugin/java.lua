local config = {
	-- cmd = { "/opt/homebrew/bin/jdtls" },
	-- on Unix
	-- TODO: See if I can use a function to dynamically get the location of jdtls?
	cmd = { "/usr/bin/jdtls" },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}
require("jdtls").start_or_attach(config)
