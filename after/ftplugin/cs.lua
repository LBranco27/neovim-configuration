vim.g.OmniSharp_server_use_mono = 1
vim.g.OmniSharp_popup_position = "peek"
vim.g.OmniSharp_popup_options = {
	winblend = 30,
	winhl = "Normal:Normal,FloatBorder:ModeMsg",
	border = "rounded",
}
vim.g.OmniSharp_popup_mappings = {
	sigNext = "<C-n>",
	sigPrev = "<C-p>",
	pageDown = { "<C-f>", "<PageDown>" },
	pageUp = { "<C-b>", "<PageUp>" },
}
vim.g.OmniSharp_highlight_groups = {
	ExcludedCode = "NonText",
}