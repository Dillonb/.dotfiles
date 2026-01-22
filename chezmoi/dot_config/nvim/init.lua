vim.opt.encoding = "utf-8"
-- Not compatible with vi (do I need this in Neovim?)
vim.opt.compatible = false
vim.opt.showcmd = true

-- Don't add a newline at the end of the file when saving
vim.opt.fixeol = false

-- 24 bit color
vim.opt.termguicolors = true

-- Spacebar as leader key
vim.g.mapleader = ' '

-- Line numbers
vim.opt.number = true

-- highlight entire line cursor is on
vim.opt.cursorline = true

-- Searches are case insensitive unless they contain a capital letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No word wrap
vim.opt.wrap = false

-- Disable swap files and sync buffers between all neovim processes
vim.opt.autoread = true
vim.opt.swapfile = false

-- Default formatting settings.
-- vim-sleuth will determine these automatically most of the time,
-- so these are just for when it can't.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.modeline = true
vim.opt.modelines = 5

-- Persistent undo between sessions
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 1000

-- Show tab characters and trailing whitespace
vim.opt.list = true

-- Always show at least this many lines above and below the cursor when scrolling
vim.opt.scrolloff = 5

-- Use system clipboard
vim.cmd [[ set clipboard+=unnamedplus ]]

-- When entering a terminal buffer, auto switch to insert mode
vim.api.nvim_create_autocmd({ "BufEnter" },
  {
    group = group,
    pattern = { "*" },
    callback = function()
      if vim.opt.buftype:get() == "terminal" then
        vim.cmd(":startinsert")
      end
    end
  })

if vim.fn.exists('g:os') == 0 then
  local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
  if is_windows then
    if vim.fn.executable("pwsh") == 1 then
      vim.opt.shell = "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      vim.opt.shell = "powershell"
    else
      vim.opt.shell = "cmd"
    end
  end
end

if vim.g.neovide then
  -- Fun little shadow under floating windows
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  -- Disable scrolling animation
  vim.g.neovide_scroll_animation_length = 0

  vim.g.neovide_confirm_quit = true

  -- Less distracting swoopy cursor
  vim.g.neovide_cursor_animation_length = 0.01
end

-- Automatically install lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

Pick_file = function()
  require "telescope.builtin".find_files({ hidden = true })
end


Copilot_toggle = function()
  if vim.g.copilot_enabled then
    vim.cmd [[ Copilot disable ]]
    vim.g.copilot_enabled = false
    vim.notify("Copilot disabled", vim.log.levels.INFO, { title = "Copilot" })
  else
    vim.cmd [[ Copilot enable ]]
    vim.g.copilot_enabled = true
    vim.notify("Copilot enabled", vim.log.levels.INFO, { title = "Copilot" })
  end
end

-- Install and setup plugins
require("lazy").setup({
  -- Parser dependency used by many plugins
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- TODO: does this need to be updated too?
      if vim.g.gcc_bin_path ~= nil then
        require("nvim-treesitter.install").compilers = { vim.g.gcc_bin_path }
      end

      -- local configs = require("nvim-treesitter.configs")

      -- configs.setup({
      --   ensure_installed = {
      --   },
      --   sync_install = false,
      --   highlight = { enable = true },
      --   indent = { enable = true },
      -- })
      require'nvim-treesitter'.install {
          "c",
          "cpp",
          "rust",
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "c_sharp",
          "java",
          "cmake",
          "clojure",
          "dockerfile",
          "gitignore",
          "git_config",
          "git_rebase",
          "gitcommit",
          "glsl",
          "ini",
          "javascript",
          "json",
          "make",
          "nix",
          "ocaml",
          "ocaml_interface",
          "powershell",
          "python",
          "yaml",
          "typst"
      }

    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
        }
      },
      -- coq requires treesitter (does cmp?)
      "nvim-treesitter/nvim-treesitter",
      -- Extra features for clangd LSP
      "p00f/clangd_extensions.nvim",
      -- Extra features for jdtls
      "mfussenegger/nvim-jdtls"
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          -- confirm with enter if something is selected, if not, insert enter as normal
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
          -- Select next with down and previous with up, or fallback if cmp is not visible
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
        preselect = cmp.PreselectMode.None
      })

      vim.lsp.enable({
        'lua_ls',
        'clangd',
        'rust_analyzer',
        'tinymist',
        'bashls',
        'omnisharp',
        'cmake',
        'terraformls',
        'ocamllsp',
        'jdtls',
        'nil_ls',
        'nixd',
        'rust_analyzer',
        'pyright',
        'gdscript',
        'gdshader_lsp'
      })

      -- Global config for all LSPs
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      -- LSP specific config
      vim.lsp.config('clangd', {
        cmd = { "clangd", "--header-insertion=never" },
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      })

      vim.lsp.config('rust_analyzer', {
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      })

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library"
              },
              ignoreDir = {
                "build",
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = true,
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        -- Still show builtin LSP error text
        virtual_text = true,
        -- Also show text from this plugin, but disabled by default
        virtual_lines = false
      })
    end,
    keys = {
      { "<Leader>e", ':lua require"lsp_lines".toggle()<CR>', desc = "Toggle lsp_lines" }
    }
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Ensure this is loaded before any other plugins
    config = function()
      vim.cmd [[colorscheme tokyonight-storm]]
    end,
  },

  -- {
  --   "tinted-theming/tinted-nvim",
  --   priority = 1000, -- Ensure this is loaded before any other plugins
  --   config = function()
  --     require("tinted-colorscheme").setup("base16-everforest-dark-medium", {
  --       supports = {
  --         tinty = false,
  --         live_reload = false
  --       }
  --     })
  --   end
  -- },

  -- Rainbow brackets, etc
  {
    "HiPhish/rainbow-delimiters.nvim",
    -- "You can set up your plugin manager to ignore the submodules. They are only used for testing and development."
    -- https://github.com/HiPhish/rainbow-delimiters.nvim/issues/173#issuecomment-2813808544
    submodules = false,
    lazy = false,
  },

  -- Nice actions for editing surrounding text
  'tpope/vim-surround',

  -- Nicer status line
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      require('lualine').setup {
        extensions = {
          'quickfix',
          'fugitive',
          'nvim-dap-ui'
        }
      }
    end
  },

  {
    'f-person/git-blame.nvim',
    lazy = true,
    init = function()
      vim.g.gitblame_enabled = 0 -- Disabled by default, so when the plugin is loaded by hitting <leader>b to execute :GitBlameToggle, it'll also be turned on
      vim.g.gitblame_virtual_text_column = 160
      vim.g.gitblame_delay = 0
    end,
    keys = {
      { '<leader>b', ':GitBlameToggle<CR>' }
    },
    cmd = {
      "GitBlameToggle",
      "GitBlameOpenFileURL"
    }
  },

  -- Show git changes on the left side of the window
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      require('gitsigns').setup()
    end
  },

  -- Autodetect indentation settings
  { 'tpope/vim-sleuth', lazy = false },

  -- Tabs
  -- {
  --   'romgrk/barbar.nvim',
  --   lazy = true,
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   dependencies = {
  --     -- Filetype icons
  --     'nvim-tree/nvim-web-devicons',
  --     -- Git status icons
  --     'lewis6991/gitsigns.nvim',
  --   },
  --   init = function()
  --     -- go to the next tab
  --     vim.keymap.set('n', '<leader>l', ':BufferNext<CR>');
  --     vim.keymap.set('n', '<leader>L', ':BufferPrevious<CR>');
  --     vim.keymap.set('n', '<leader>h', ':BufferPrevious<CR>');
  --     vim.keymap.set('n', '<C-w>', ':BufferClose<CR>');
  --   end,
  -- },
  {
    'nvim-mini/mini.tabline',
    version = false,
    init = function()
      require('mini.tabline').setup()
      -- go to the next tab
      vim.keymap.set('n', '<leader>l', ':bnext<CR>');
      vim.keymap.set('n', '<leader>L', ':bprevious<CR>');
      vim.keymap.set('n', '<leader>h', ':bprevious<CR>');
      vim.keymap.set('n', '<C-w>', ':bdelete<CR>');
    end,
  },

  -- File browser
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = true,
    cmd = "Neotree",
    config = function()
      require("neo-tree").setup({
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
        close_if_last_window = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          use_libuv_file_watcher = true,
        }
      })
    end,
  },

  -- Search
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--hidden",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          file_ignore_patterns = {
            "node_modules",
            "^.git/",
            "^.git\\"
          }
        }
      }
    end,
    keys = {
      -- Find files by filename
      { '<leader>o', ':lua Pick_file()<CR>',    noremap = true, silent = true },
      { '<C-p>',     ':lua Pick_file()<CR>',    noremap = true, silent = true },
      -- Find currently open files by filename
      { '<leader>p', ':Telescope buffers<CR>' },
      -- Search in all files
      { '<C-f>',     ':Telescope live_grep<CR>' }
    },
    cmd = "Telescope"
  },

  -- show a lightbulb emoji when LSP code actions are available
  {
    'kosayoda/nvim-lightbulb',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end,
  },

  -- :q closes the current tab/buffer, and only closes Neovim if this buffer is the last one.
  {
    'Dillonb/betterquit.nvim',
    init = function()
      require("betterquit").setup {}
    end,
  },

  -- Set the working directory to the root of the project
  -- {
  --   'notjedi/nvim-rooter.lua',
  --   lazy = false,
  --   init = function()
  --     require('nvim-rooter').setup()
  --   end,
  -- },

  -- Git integration
  'tpope/vim-fugitive',

  -- Commenting
  {
    'tpope/vim-commentary',
    init = function()
      -- map ctrl-/ to toggle comments
      -- Some terminals will send ctrl-/ as ctrl-_
      -- but some (newer?) will send it correctly, so map both
      vim.keymap.set({ 'n', 'v' }, '<C-_>', ":Commentary<CR>")
      vim.keymap.set({ 'n', 'v' }, '<C-/>', ":Commentary<CR>")
    end,
  },

  -- Automatically close braces, parens, etc, and allows you to type "through"
  {
    'windwp/nvim-autopairs',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
      require("nvim-autopairs").setup()
    end
  },

  -- Debugger
  {
    'mfussenegger/nvim-dap',
    init = function()
      local dap = require("dap")
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" }
      }
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }
    end
  },

  -- UI for debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    init = function()
      local dap = require("dapui")
      dap.setup()
      -- vim.keymap.set('n', '<leader>d', dap.toggle);
      vim.cmd.amenu([[PopUp.Debug\ UI <Cmd>lua require("dapui").toggle()<CR>]])
      vim.cmd.amenu([[PopUp.Toggle\ Breakpoint <Cmd>lua require("dap").toggle_breakpoint()<CR>]])
      vim.keymap.set('n', '<leader>bp', require("dap").toggle_breakpoint);
    end
  },

  -- Automatic session saving + restore functionality
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  -- Integration with tmux, nicer split navigation
  {
    'mrjones2014/smart-splits.nvim',
    init = function()
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)

      vim.keymap.set('t', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('t', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('t', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('t', '<C-l>', require('smart-splits').move_cursor_right)
    end
  },

  -- Changes made in a quickfix window are reflected in the actual file
  {
    "stefandtw/quickfix-reflector.vim"
  },

  -- Find unmapped keys easily
  {
    "meznaric/key-analyzer.nvim",
    opts = {},
    cmd = "KeyAnalyzer",
  },

  -- Misc mini plugins
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      quickfile = { enabled = true },
      bigfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "p", desc = "Find File", action = ":lua Pick_file()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Current Dir Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "M", desc = "Mason", action = ":Mason" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          {
            pane = 2,
            section = 'terminal',
            icon = ' ',
            title = 'Git Status',
            enabled = vim.fn.isdirectory('.git') == 1 and vim.fn.executable("hub") == 1,
            cmd = 'hub diff --stat -B -M -C',
            height = 8,
            padding = 2,
            indent = 0
          },
          { section = "startup" },
        },
      }
    },
    init = function()
      vim.keymap.set('n', '<leader>g', require("snacks").lazygit.open)
      vim.keymap.set('n', '<leader>t', require("snacks").terminal.toggle);
    end
  },

  -- Nicer UI for selections
  {
    "stevearc/dressing.nvim"
  },

  -- Show the first line of the function, class, etc, at the top of the screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require 'treesitter-context'.setup {
        enable = true,
        mode = 'topline',
        max_lines = 4,
        trim_scope = 'inner'
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "https://github.com/github/copilot.vim.git",
    init = function()
      vim.g.copilot_enabled = true
    end,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { '<Tab>',      '<Plug>(copilot-accept-line)', mode = "i" },
      { '<leader>ct', Copilot_toggle,                mode = "n" },
    }
  },

  {
    "mason-org/mason.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    init = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      require("mason-lspconfig").setup({
        automatic_enable = true
      })
      require("mason-nvim-dap").setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { "ConformInfo" },
    keys = {
      {
        '<leader>fb',
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer"
      }
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        nix = { "nixfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
      require("edgy").open()
    end,
    opts = {
      close_when_all_hidden = false, -- Leave sidebar open even when all windows are hidden
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
          -- pinned = true,
          open = function()
            vim.cmd [[Neotree]]
          end,
        },
      }
    }
  }
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    -- Special keybinds for when an LSP is available

    -- shift-k for hover information about a symbol
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.cmd.amenu([[PopUp.LSP\ hover <Cmd>lua vim.lsp.buf.hover()<CR>]])

    -- gd to go to definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.cmd.amenu([[PopUp.Go\ to\ definition <Cmd>lua vim.lsp.buf.definition()<CR>]])

    -- gi to go to implementation
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- <leader> rn to rename the symbol under the cursor
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.cmd.amenu([[PopUp.Rename\ symbol <Cmd>lua vim.lsp.buf.rename()<CR>]])

    -- Switch between C/C++ source and header files
    vim.keymap.set('n', '<leader>sh', ':ClangdSwitchSourceHeader<CR>')

    -- quick fix (LSP code actions)
    vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)
    vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])

    -- Find usages
    vim.keymap.set('n', '<leader>fu', ':Telescope lsp_references<CR>')
    vim.cmd.amenu([[PopUp.Find\ usages <Cmd>:Telescope lsp_references<CR>]])

    -- ctrl-p in insert mode to get 'signature help' for the function call you're currently writing
    vim.keymap.set('i', '<C-p>', vim.lsp.buf.signature_help, opts)

    -- Toggle inlay hints
    vim.keymap.set('n', '<leader>ih', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, opts)

    -- Search for symbols in project
    vim.keymap.set('n', '<leader>s', ':lua require"telescope.builtin".lsp_dynamic_workspace_symbols{}<CR>')

    -- I don't know if this is necessary - hook completion and tags up to the LSP manually
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.supports_method("textDocument/completion") then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.supports_method("textDocument/definition") then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
      end
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(args)
    vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
  end
})
