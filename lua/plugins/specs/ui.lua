return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },
	{ "nvim-tree/nvim-web-devicons" },
	{ "preservim/nerdtree" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      'alpha',
      'dashboard',
      'NvimTree',
      'Outline',
      'packer',
      'diff',
    },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filesize'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {'filename'},
    lualine_b = {},
    lualine_c = {'filepath'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
})
		end,
	},
}
