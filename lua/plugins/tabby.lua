return {
	"nanozuki/tabby.nvim",
	event = "TabNew",
	config = function()
		require("tabby").setup({
			line = function(line)
				return {
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and "TabLineSel" or "TabLine"
						return {
							line.sep("", hl, "TabLineFill"),
							tab.number(),
							tab.name(),
							line.sep("", hl, "TabLineFill"),
							hl = hl,
							margin = " ",
						}
					end),
					line.spacer(),
					hl = "TabLineFill",
				}
			end,
		})
	end,
}
