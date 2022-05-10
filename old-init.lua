local config = {

	-- Set colorscheme
	colorscheme = "default_theme",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
			shell = vim.fn.has("win32") == 1 and "pwsh.exe" or vim.o.shell,
			shellquote = vim.opt.shellxquote,
			fileformats = "unix",
			nocompatible = true
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
			maplocalleader = "\\",
			shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
			shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
			shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
    },
  },

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

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
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
					},

					local myColorsGroup = vim.api.nvim_create_augroup("MyColors", { clear = true })
					vim.api.nvim_create_autocmd("FileType", {
						desc = "Update VimWiki Colors",
						pattern = {"*.md"},
						group = myColorsGroup,
						command = " ColorScheme * highlight VimwikiList guibg=NONE ",
					})

					vim.keymap.set("n", "<leader>ww", ":VimwikiIndex<CR>", { noremap = true })
				end,
			},

			{ "dhruvasagar/vim-table-mode" },

-- 			{
-- 				"jalvesaq/Nvim-R",
-- 				config = function ()
-- 				nvim.g['R_path'] = "$HOME\\scoop\\apps\\r-release\\current\\bin;$HOME\\scoop\\apps\\rtools\\current",
-- 				nvim.g['R_syntax_fun_pattern'] = 1,
-- 				nvim.g['R_set_home_env'] = 0,
-- 				nvim.g['R_assign'] = 0,
-- 				nvim.g['R_external_term'] = 0,
-- 			end,
-- 			},

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
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua", "powershell_es" },
    },
		packer = {
			compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
		},
	},

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server.name].setup(opts)
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

    null_ls.setup {
      debug = false,
      sources = {
        -- Set a formatter
        formatting.rufo,
        require("null-ls").builtins.stylua, -- Styling Lua.
        -- Set a linter
        diagnostics.rubocop,
      },
      -- NOTE: You can remove this on attach function to disable format on save
      on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_augroup("lsp_format", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            group = "lsp_format",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end,
    }
  end,

	-- This function is run last
	-- good place to configure mappings and vim options
	polish = function()
		-- Set key bindings
	vim.keymap.set("n", "<C-s>", ":w!<CR>")

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

	end,


}

return config
