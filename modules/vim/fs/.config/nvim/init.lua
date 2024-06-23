vim.opt.encoding = "utf-8"
-- Not compatible with vi (do I need this in Neovim?)
vim.opt.compatible = false
vim.opt.showcmd = true

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

-- Install and setup plugins
require("lazy").setup({
    -- LSP
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = {
        -- LSP completion
        { "ms-jpq/coq_nvim", branch = "coq" },
        -- Snippets
        { "ms-jpq/coq.artifacts", branch = "artifacts" },
        -- Additional sources
        { 'ms-jpq/coq.thirdparty', branch = "3p" },
        -- coq requires treesitter
        "nvim-treesitter/nvim-treesitter",
        -- Extra features for clangd LSP
        "p00f/clangd_extensions.nvim",
        -- Extra features for jdtls
        "mfussenegger/nvim-jdtls"
      },
      init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up'
        }
      end,
      config = function()
        local lspconfig = require('lspconfig')
        local coq = require('coq')

        if vim.fn.executable("pyright") then
          lspconfig.pyright.setup(coq.lsp_ensure_capabilities())
        end

        if vim.fn.executable("clangd") then
          lspconfig.clangd.setup(coq.lsp_ensure_capabilities())
        end

        if vim.fn.executable("nil") then
          lspconfig.nil_ls.setup(coq.lsp_ensure_capabilities())
        end

        if vim.fn.executable("jdtls") then
          lspconfig.jdtls.setup(coq.lsp_ensure_capabilities())
        end

        if vim.fn.executable("ocamllsp") then
          lspconfig.ocamllsp.setup(coq.lsp_ensure_capabilities())
        end

        if vim.fn.executable("cmake-language-server") then
          lspconfig.cmake.setup(coq.lsp_ensure_capabilities())
        end

      end,
    },

    -- Gruvbox my beloved
    {
      "lifepillar/vim-gruvbox8",
      lazy = false,
      config = function()
        vim.cmd [[colorscheme gruvbox8]]
      end,
    },

    -- Nice actions for editing surrounding text
    'tpope/vim-surround',

    -- Nicer status line
    'vim-airline/vim-airline',

    -- Show git changes on the left side of the window
    'airblade/vim-gitgutter',

    -- Autodetect indentation settings
    {'tpope/vim-sleuth', lazy = false},

    -- Tabs
    {
      'romgrk/barbar.nvim',
      dependencies = {
        -- Filetype icons
        'nvim-tree/nvim-web-devicons',
        -- Git status icons
        'lewis6991/gitsigns.nvim',
      },
      init = function()
        -- go to the next tab
        vim.keymap.set('n', '<leader>l', ':BufferNext<CR>');
        vim.keymap.set('n', '<leader>L', ':BufferPrevious<CR>');
        vim.keymap.set('n', '<C-w>', ':BufferClose<CR>');
      end,
    },

    -- File browser
    {
      'ms-jpq/chadtree',
      lazy = false,
      init = function()
        vim.keymap.set('n', '<leader>b', ':CHADopen<CR>');
      end
    },

    -- Search
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- Find files by filename
        vim.keymap.set('n', '<leader>o', ':Telescope find_files<CR>');
        vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>');

        -- Find currently open files by filename
        vim.keymap.set('n', '<leader>p', ':Telescope buffers<CR>');

        -- Search in all files
        vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>');
      end,
    },

    -- show a lightbulb emoji when LSP code actions are available
    {
      'kosayoda/nvim-lightbulb',
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
        require("betterquit").setup{}
      end,
    },

    -- Set the working directory to the root of the project
    {
      'notjedi/nvim-rooter.lua',
      lazy = false,
      init = function()
        require('nvim-rooter').setup()
      end,
    },

    -- Git integration
    'tpope/vim-fugitive',

    -- Commenting
    {
      'tpope/vim-commentary',
      lazy = false,
      init = function()
        -- map ctrl-/ to toggle comments
        -- Some terminals will send ctrl-/ as ctrl-_
        -- but some (newer?) will send it correctly, so map both
        vim.keymap.set({'n', 'v'}, '<C-_>', ":Commentary<CR>", opts)
        vim.keymap.set({'n', 'v'}, '<C-/>', ":Commentary<CR>", opts)
      end,
    },

    -- Automatically close braces, parens, etc, and allows you to type "through" 
    {
      'windwp/nvim-autopairs',
      init = function()
        require("nvim-autopairs").setup()
      end
    },

    -- Embedded toggleable terminal
    {
      'akinsho/toggleterm.nvim',
      version = "*",
      config = true,
      init = function()
        vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>');
      end
    },

    -- Task runner
    {
      'stevearc/overseer.nvim',
      init = function()
        require('overseer').setup()
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
      end
    },

    -- Automatic session save/restore
    {
      'rmagatti/auto-session',
      init = function()
        require('auto-session').setup()
      end
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

    -- Search for symbols in project
    vim.keymap.set('n', '<leader>s', ':Telescope lsp_dynamic_workspace_symbols<CR>')

    -- enable clangd inlay hints
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()

    -- I don't know if this is necessary - hook completion and tags up to the LSP manually
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method("textDocument/completion") then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.supports_method("textDocument/definition") then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(args)
    vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
  end
})
