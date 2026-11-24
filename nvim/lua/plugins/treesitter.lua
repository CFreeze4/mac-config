return {
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false, -- ADD THIS (critical)
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"astro",
				"cmake",
				"cpp",
				"css",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"hcl",
				"http",
				"java",
				"php",
				"rust",
				"scss",
				"sql",
				"svelte",
				"latex",
				"typst",
				"terraform",
				"vue",
			},
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
}
