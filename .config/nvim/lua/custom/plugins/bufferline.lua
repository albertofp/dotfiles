return {
	'akinsho/bufferline.nvim',
	config = function()
		require('bufferline').setup()
	end,
	lazy = true,
	version = '*',
	dependencies = 'nvim-tree/nvim-web-devicons',
}
