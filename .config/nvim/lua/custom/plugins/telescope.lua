return {
	{
		'nvim-telescope/telescope.nvim',
		lazy = true,
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'BurntSushi/ripgrep',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
						layout_config = {
							height = 0.70
						}
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,             -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
					},
				},
			}
			require('telescope').load_extension 'file_browser'
			pcall(require('telescope').load_extension, 'fzf')
		end,
		{
			'nvim-telescope/telescope-file-browser.nvim',
			dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
		}
	}
}
