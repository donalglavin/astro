vim.opt.shell = vim.fn.has("win32") == 1 and "pwsh.exe" or vim.o.shell

vim.cmd([[ 
let maplocalleader = "\\"
]])

vim.cmd([[
let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=
]])

vim.cmd([[
set ff=unix
set nocompatible
filetype plugin on
syntax on
]])

local config = {

	-- Set colorscheme
	colorscheme = "default_theme",

	-- Default theme configuration
	default_theme = {
		diagnostics_style = "none",
		-- Modify the color table
		colors = {
			fg = "#abb2bf",
		},
		-- Modify the highlight groups
		highlights = function(highlights)
			local C = require("default_theme.colors")

			highlights.Normal = { fg = C.fg, bg = C.bg }
			return highlights
		end,
	},

	-- Disable default plugins
	enabled = {
		bufferline = true,
		neo_tree = true,
		lualine = true,
		gitsigns = true,
		colorizer = true,
		toggle_term = true,
		comment = true,
		symbols_outline = true,
		indent_blankline = true,
		dashboard = true,
		which_key = true,
		neoscroll = true,
		ts_rainbow = true,
		ts_autotag = true,
	},

	-- Configure plugins
	plugins = {
		-- Add plugins, the packer syntax without the "use"
		init = {

			-- VimWiki
			{
				"vimwiki/vimwiki",
				config = function()
					vim.g.vimwiki_list = {
						{
							path = "~/.projects/wiki",
							syntax = "markdown",
							ext = ".md",
						},
					}

					vim.cmd([[
					augroup MyColors
					autocmd!
					autocmd ColorScheme * highlight VimwikiList guibg=NONE
					augroup end
					]])

					vim.api.nvim_set_keymap("n", "<leader>ww", ":VimwikiIndex<CR>", { noremap = true })
				end,
			},

			{ "dhruvasagar/vim-table-mode" },

			{
				"jalvesaq/Nvim-R",
				vim.cmd([[
				let R_path = "$HOME\\scoop\\apps\\r-release\\current\\bin;$HOME\\scoop\\apps\\rtools\\current"
				let R_syntax_fun_pattern = 1
				let R_set_home_env = 0
				let R_assign = 0
				let R_external_term = 0
				]]),
			},

			{ "ElPiloto/telescope-vimwiki.nvim" },

			{ "andweeb/presence.nvim" },
			{
				"nvim-telescope/telescope-file-browser.nvim",
				config = function()
					require("telescope").load_extension("file_browser")
					vim.api.nvim_set_keymap("n", "<leader><leader>", ":Telescope file_browser<CR>", { noremap = true })
				end,
			},
			{
				"nvim-treesitter/playground",
				config = function()
					require("nvim-treesitter.configs").setup({
						playground = {
							enable = true,
							disable = {},
							updatetime = 25,
							persist_queries = false,
							keybindings = {
								toggle_query_editor = "o",
								toggle_hl_groups = "i",
								toggle_injected_languages = "t",
								toggle_anonymous_nodes = "a",
								toggle_language_display = "I",
								focus_language = "f",
								unfocus_language = "F",
								update = "R",
								goto_node = "<cr>",
								show_help = "?",
							},
						},
					})
				end,
			},
			{
				"ray-x/lsp_signature.nvim",
				event = "BufRead",
				config = function()
					require("lsp_signature").setup()
				end,
			},
		},
		-- All other entries override the setup() call for default plugins
		treesitter = {
			ensure_installed = {
				"lua",
				"json",
				"yaml",
				"css",
				"fennel",
				"html",
				"javascript",
				"markdown",
				"query",
				"ledger",
				"julia",
				"r",
				"python",
				"typescript",
				"regex",
				"jsdoc",
				"go",
			},
		},
		packer = {
			compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
		},
	},

	-- Add paths for including more VS Code style snippets in luasnip
	luasnip = {
		vscode_snippet_paths = {},
	},

	-- Modify which-key registration
	["which-key"] = {
		-- Add bindings to the normal mode <leader> mappings
		register_n_leader = {
			-- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
		},
	},

	-- Extend LSP configuration
	lsp = {
		-- add to the server on_attach function
		-- on_attach = function(client, bufnr)
		-- end,

		-- override the lsp installer server-registration function
		-- server_registration = function(server, opts)
		--   server:setup(opts)
		-- end

		-- Add overrides for LSP server settings, the keys are the name of the server
		["server-settings"] = {
			-- example for addings schemas to yamlls
			-- yamlls = {
			--   settings = {
			--     yaml = {
			--       schemas = {
			--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
			--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			--       },
			--     },
			--   },
			-- },
		},
	},

	-- Diagnostics configuration (for vim.diagnostics.config({}))
	diagnostics = {
		virtual_text = true,
		underline = true,
	},

	-- null-ls configuration
	["null-ls"] = function()
		-- Formatting and linting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim
		local status_ok, null_ls = pcall(require, "null-ls")
		if not status_ok then
			return
		end

		-- Check supported formatters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local formatting = null_ls.builtins.formatting

		-- Check supported linters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local diagnostics = null_ls.builtins.diagnostics

		null_ls.setup({
			debug = false,
			sources = {
				-- Set a formatter
				formatting.rufo,
				require("null-ls").builtins.formatting.stylua,
				-- require("null-ls").builtins.diagnostics.eslint,
				-- require("null_ls").builtins.completion.spell,
				-- Set a linter
				diagnostics.rubocop,
			},
			-- NOTE: You can remove this on attach function to disable format on save
			on_attach = function(client)
				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end,
		})
	end,

	-- This function is run last
	-- good place to configure mappings and vim options
	polish = function()
		local opts = { noremap = true, silent = true }
		local map = vim.api.nvim_set_keymap
		local set = vim.opt
		-- Set options
		set.relativenumber = true

		-- Set key bindings
		map("n", "<C-s>", ":w!<CR>", opts)

		-- Set autocommands
		vim.cmd([[
                augroup packer_conf
                autocmd!
                autocmd bufwritepost plugins.lua source <afile> | PackerSync
                augroup end
                ]])
	end,
}

return config
