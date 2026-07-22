local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp_ok then
	-- cmp-nvim-lsp returns only textDocument.completion; merge it with the base
	-- capabilities so we keep general.positionEncodings and other defaults.
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

local function on_attach(client, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
	vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find references" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Actions" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

vim.diagnostic.config({
	virtual_text = { prefix = "\u{25CF}", source = "if_many" },
	signs = true,
	update_in_insert = false,
	float = { border = "rounded", source = "always" },
})

-- Default capabilities for all LSP clients (including those configured elsewhere,
-- e.g. GitLab Duo) so every client uses UTF-16 and avoids mixed encodings.
vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.config("ruff", {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		client.server_capabilities.completionProvider = nil
	end,
})

vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
				typeCheckingMode = "basic",
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.config("gdscript", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "gdscript" },
})

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("gitlab_duo", {
	capabilities = capabilities,
})

vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gdscript")
vim.lsp.enable("ts_ls")
vim.lsp.enable("rust_analyzer")

-- Disable tvm_ffi_navigator (Apache TVM FFI): ffi-navigator is not installed.
-- Override its filetypes so it can never auto-start, even if re-enabled later.
vim.lsp.config("tvm_ffi_navigator", { filetypes = {} })
vim.lsp.enable("tvm_ffi_navigator", false)
