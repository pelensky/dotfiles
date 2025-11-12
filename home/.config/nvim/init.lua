-- ==============================================================================
-- NEOVIM CONFIGURATION
-- ==============================================================================

if vim.g.vscode then
  -- VSCode extension - minimal config
else
  -- Full Neovim configuration
end

-- ==============================================================================
-- LAZY.NVIM PLUGIN MANAGER SETUP
-- ==============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==============================================================================
-- PLUGINS
-- ==============================================================================

require("lazy").setup({
  -- Whitespace management
  { "ntpeters/vim-better-whitespace" },

  -- Window management
  { "roman/golden-ratio" },

  -- File explorer
  { "scrooloose/nerdtree" },

  -- Status line
  { "bling/vim-airline" },

  -- Tmux integration
  { "pivotal/tmux-config" },

  -- Linter
  {
    "dense-analysis/ale",
    config = function()
      vim.g.ale_fix_on_save = 0
      vim.g.ale_lint_on_save = 1
      vim.g.ale_use_global_executables = 0
      vim.g.ale_fixers = {
        ruby = { "rubocop" },
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
        css = { "prettier" },
        scss = { "prettier", "stylelint" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" }
      }
      vim.api.nvim_set_keymap('n', '<leader>af', ':ALEFix<CR>', { noremap = true, silent = false })
    end
  },

  -- TreeSitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "css", "html", "javascript", "lua", "svelte", "typescript" },
      })
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
      vim.keymap.set('n', '<C-c>', '<Plug>(comment_toggle_linewise_current)')
      vim.keymap.set('x', '<C-c>', '<Plug>(comment_toggle_blockwise_visual)')
    end,
  },

  -- Color scheme
  {
    "iammerrick/nova-vim",
    config = function()
      vim.cmd.colorscheme('nova')
    end,
  },

  -- GitHub Copilot
  { "github/copilot.vim" },

  -- Rainbow CSV
  { "mechatroner/rainbow_csv" },

  -- FZF fuzzy finder
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        files = {
          cmd = "rg --files --hidden",
        },
      })
      vim.keymap.set("n", "<C-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
    end
  },

  -- LSP + Autocomplete
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")

      lspconfig.ts_ls.setup({
        capabilities = cmp_lsp.default_capabilities(),
        on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

          -- Organize imports with `,oi`
          vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
              apply = true,
            })
            -- Then run ALEFix
            vim.defer_fn(function()
              vim.cmd("ALEFix")
            end, 50)
          end, opts)
        end,
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", ".git"),
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
      })
    end,
  },
})

-- ==============================================================================
-- BASIC SETTINGS
-- ==============================================================================

vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.showmatch = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.fileformat = "unix"
vim.opt.background = "dark"
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.backspace = "indent,eol,start"
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.mouse = ""

-- Leader key
vim.g.mapleader = ","

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Highlight trailing whitespace
vim.cmd([[match Error /\s\+$/]])

-- ==============================================================================
-- PLUGIN CONFIGURATION
-- ==============================================================================

-- NERDTree
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true })
vim.g.NERDTreeShowHidden = 1

-- ==============================================================================
-- KEYBINDINGS
-- ==============================================================================

-- Movement - j/k move through wrapped lines
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', 'gj', 'j', { noremap = true })
vim.keymap.set('n', 'gk', 'k', { noremap = true })

-- Disable arrow keys
vim.keymap.set('n', '<up>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<down>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<left>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<right>', '<Nop>', { noremap = true })

-- Command typo fixes
vim.cmd([[
  command! W w
  command! Q q
  command! WQ wq
  command! Wq wq
]])

-- Strip whitespace
vim.keymap.set('n', '<leader>ws', ':StripWhitespace<CR>', { noremap = true })

-- Reindent entire file
vim.keymap.set('n', '==', 'gg=G``', { noremap = true })

-- ==============================================================================
-- ADVANCED FEATURES
-- ==============================================================================

-- Enable matchit for % jumping between tags
vim.cmd([[packadd! matchit]])

-- Use ripgrep for grep if available
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

-- Filetype detection
vim.cmd [[
  autocmd BufNewFile,BufRead .env.*  setf dosini
]]

-- Spell check for markdown and git commits
vim.cmd [[
  autocmd FileType markdown setlocal spell
  autocmd FileType gitcommit setlocal spell
]]
