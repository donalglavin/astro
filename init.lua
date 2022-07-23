local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme
  colorscheme = "default_theme",

  -- Override highlight groups in any theme
  highlights = {
    -- duskfox = { -- a table of overrides
    --   Normal = { bg = "#000000" },
    -- },
    default_theme = function(highlights) -- or a function that returns one
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      highlights.VimwikiList = { fg = C.fg, bg = NONE}
      return highlights
    end,
  },
  
  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
			shell = vim.fn.has("win32") == 1 and "pwsh.exe" or vim.o.shell,
      -- shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
      -- shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
      -- shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
			maplocalleader = "\\",
			vimwiki_list = {{
				path = "~/.projects/wiki",
				syntax = "markdown",
				ext = ".md",
			},
		},
    R_path = "$HOME\\scoop\\apps\\r-release\\current\\bin;$HOME\\scoop\\apps\\rtools\\current",
    R_syntax_fun_pattern = 1,
    R_set_home_env = 0,
    R_assign = 0,
    R_external_term = 0,
  },
},

-- Default theme configuration
default_theme = {
  diagnostics_style = { italic = true },
  -- Modify the color table
  colors = {
    fg = "#abb2bf",
  },
  plugins = { -- enable or disable extra plugin highlighting
  aerial = true,
  beacon = false,
  bufferline = true,
  dashboard = true,
  highlighturl = true,
  hop = false,
  indent_blankline = true,
  lightspeed = false,
  ["neo-tree"] = true,
  notify = true,
  ["nvim-tree"] = false,
  ["nvim-web-devicons"] = true,
  rainbow = true,
  symbols_outline = false,
  telescope = true,
  vimwiki = false,
  ["which-key"] = true,
},
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
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },
      ["declancm/cinnamon.nvim"] = { disable = true },
      -- You can also add new plugins here as well:
			{ "vimwiki/vimwiki" },
			{ "dhruvasagar/vim-table-mode" },
      { "andweeb/presence.nvim" },
			{ "jalvesaq/Nvim-R" },
			{ "ElPiloto/telescope-vimwiki.nvim" },
      {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function()
          require("lsp_signature").setup()
        end,
      },
    },
    -- All other entries override the setup() call for default plugins
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.rufo,
        -- Set a linter
        null_ls.builtins.diagnostics.rubocop,
      }
      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table
    end,
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
				"python",
				"typescript",
				"regex",
				"jsdoc",
				"go"
    },},
    ["nvim-lsp-installer"] = {
      ensure_installed = {
        "sumneko_lua",
        "powershell_es" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
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
         "sumneko_lua",
        "powershell_es"
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

    -- Configure Shell for Windows.
    vim.cmd([[
    let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
    ]])
  end,
}

return config
