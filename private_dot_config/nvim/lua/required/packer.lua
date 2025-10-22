vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
	use "wbthomason/packer.nvim"

	-- file navigation
	use {
	  "nvim-telescope/telescope.nvim",
	  tag = "0.1.8",
	  requires = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons"}
	}

	-- themes
	use {
		"tpaau-17DB/habamax.nvim",
		requires={ "rktjmp/lush.nvim" },
	}

	-- colorize hexcodes
	use "norcalli/nvim-colorizer.lua"

	-- colorcolumn
	use "ecthelionvi/NeoColumn.nvim"

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})

	-- LSP servers
	vim.lsp.config["luals"] = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				}
			}
		}
	}

	-- rust tools
	use "mrcjkb/rustaceanvim"

	-- mason
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"

	-- autocompletion
	use "neoclide/coc.nvim"

	-- Automatic bracket and quote completion
	use "windwp/nvim-autopairs"

	-- status bar
	use {
		"nvim-lualine/lualine.nvim",
		requires = {"nvim-tree/nvim-web-devicons"}
	}

	use "NMAC427/guess-indent.nvim"

	use {
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = {
					char = "┊",
					highlight = "IblIndent",
				},
				scope = { enabled = false },
			})
		end
	}

	use {
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup {
				signs = {
					add          = { text = "+" },
					change       = { text = "#" },
					delete       = { text = "-" },
					topdelete    = { text = "‾" },
					changedelete = { text = "~" },
					untracked    = { text = "┆" },
				},
				signs_staged = signs,
				signs_staged_enable = true,
				signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
				numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1
			},
		}
		end
	}

	use {
		"goolord/alpha-nvim",
		requires = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim"
		},
		config = function()
			require"alpha".setup(require"alpha.themes.dashboard".config)
		end
	}

	use "rcarriga/nvim-notify"
	vim.notify = require("notify")
end)
