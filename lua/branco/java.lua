local root_marker = vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
local config = {
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
	root_dir = root_marker and vim.fs.dirname(root_marker) or vim.fn.getcwd(),
}
require("jdtls").start_or_attach(config)
