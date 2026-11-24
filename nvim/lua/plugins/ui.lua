return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
		keys = {},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		config = function()
			local ok, p = pcall(require, "divine-machinery.palette")
			if not ok then
				return
			end

			require("incline").setup({
				debounce_threshold = { falling = 50, rising = 10 },
				hide = { cursorline = false, focused_win = false, only_win = false },
				highlight = {
					groups = {
						InclineNormal = { guifg = p.fg, guibg = p.bg_alt, gui = "bold" },
						InclineNormalNC = { guifg = p.gray, guibg = "NONE", gui = "italic" },
					},
				},
				ignore = {
					buftypes = "special",
					filetypes = {},
					floating_wins = true,
					unlisted_buffers = true,
					wintypes = "special",
				},
				render = function(props)
					local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if name == "" then
						name = "[No Name]"
					end

					local modified = vim.bo[props.buf].modified
					local dim = props.focused and p.gray or p.gray
					local accent = props.focused and p.red or p.gray

					return {
						{ "[ ", guifg = accent },
						{ name },
						modified and { " *", guifg = p.red, gui = "bold" } or "",
						{ " ]", guifg = accent },
					}
				end,
				window = {
					margin = { horizontal = 1, vertical = 1 },
					options = { signcolumn = "no", wrap = false },
					overlap = { borders = true, statusline = false, tabline = false, winbar = false },
					padding = 1,
					padding_char = " ",
					placement = { horizontal = "right", vertical = "top" },
					width = "fit",
					winhighlight = {
						active = { EndOfBuffer = "None", Normal = "InclineNormal", Search = "None" },
						inactive = { EndOfBuffer = "None", Normal = "InclineNormalNC", Search = "None" },
					},
					zindex = 50,
				},
			})
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 2000,
		opts = {
			dashboard = {
				width = 60,
				pane_gap = 8,
				preset = {
					keys = {
						{ key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ key = "n", desc = "New File", action = ":ene | startinsert" },
						{ key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ key = "s", desc = "Restore Session", section = "session" },
						{ key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
						{ key = "q", desc = "Quit", action = ":qa" },
					},
					header = [[

Okay... Let's see
I guess that I'm confused again
Am I here, or am I there?
I don't know..
Over there, I'm everywhere,
I know that...
But here is connected to over there,
is that right?
But then, where is the real me
after all is said and done?
Oh, there is no real me,
I guess that's it.
I only exist inside those people
aware of my existence.
But what about this me that
I can hear talking about
right here and now?
It's me, isn't it?
This me that I hear talking...
Who is it?
Who's me?

]],
				},
				formats = {
					header = { "%s", align = "left" },
				},
				sections = {
					-- left pane: the monologue
					{ section = "header", pane = 1, align = "left" },

					-- right pane: options
					{ pane = 2, padding = 6 },
					{ section = "keys", pane = 2, gap = 1, padding = 1 },
				},
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local p = require("divine-machinery.palette")

			-- Mode shown as colored bold text on the statusline background.
			-- Change bg to p.bg_alt for a faint tinted bar instead.
			local function mode(accent)
				return {
					a = { fg = accent, bg = "NONE", gui = "bold" },
					b = { fg = p.fg, bg = "NONE" },
					c = { fg = p.gray, bg = "NONE" },
				}
			end

			opts.options = opts.options or {}
			opts.options.theme = {
				normal = mode(p.fg),
				insert = mode(p.green),
				visual = mode(p.blue),
				replace = mode(p.red),
				command = mode(p.magenta),
				inactive = mode(p.gray),
			}

			-- No filled shapes between sections; thin broken line between components.
			opts.options.section_separators = { left = "", right = "" }
			opts.options.component_separators = { left = "╎", right = "╎" }

			opts.sections = opts.sections or {}

			-- Mode as a bracketed label, matching the incline filename.
			opts.sections.lualine_a = {
				{
					"mode",
					fmt = function(s)
						return "[ " .. s .. " ]"
					end,
				},
			}

			-- Remove the clock (LazyVim puts it in lualine_z).
			opts.sections.lualine_z = {}
		end,
	},
}
