vim.opt.encoding = "utf-8"
-- Not compatible with vi (do I need this in Neovim?)
vim.opt.compatible = false
vim.opt.showcmd = true

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

        lspconfig.pyright.setup(coq.lsp_ensure_capabilities())
        lspconfig.clangd.setup(coq.lsp_ensure_capabilities())
        lspconfig.nil_ls.setup(coq.lsp_ensure_capabilities())
        lspconfig.jdtls.setup(coq.lsp_ensure_capabilities())
        lspconfig.ocamllsp.setup(coq.lsp_ensure_capabilities())
        lspconfig.cmake.setup(coq.lsp_ensure_capabilities())
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
    {
      'vim-airline/vim-airline',
      config = function()
        vim.g.airline_section_b = '%{strftime("%c")}'
      end,
    },

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
    {'ms-jpq/chadtree', lazy = false},

    -- Search
    {
      'nvim-telescope/telescope.nvim', 
      branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- Find files by filename
        vim.keymap.set('n', '<leader>o', ':Telescope find_files<CR>');
        --
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
    }
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    -- Special keybinds for when an LSP is available

    -- shift-k for hover information about a symbol
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    -- gd to go to definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    -- gi to go to implementation
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- <leader> rn to rename the symbol under the cursor
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- Switch between C/C++ source and header files
    vim.keymap.set('n', '<leader>sh', ':ClangdSwitchSourceHeader<CR>')

    -- quick fix (LSP code actions)
    vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)

    -- Find usages
    vim.keymap.set('n', '<leader>fu', ':Telescope lsp_references<CR>')

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