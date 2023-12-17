return {
	'f-person/git-blame.nvim',
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require('gitblame').setup {
			enabled = false,
		}
	end,
}
