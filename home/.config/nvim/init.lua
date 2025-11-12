-- ~/.config/nvim/init.lua
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()

vim.cmd('source ~/.vimrc')

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
end

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

require("lazy").setup({
  { "ntpeters/vim-better-whitespace" },
  { "roman/golden-ratio" },
  { "scrooloose/nerdtree" },
  { "bling/vim-airline" },
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

  -- Colours
  {
    "iammerrick/nova-vim",
    config = function()
      vim.cmd.colorscheme('nova')
    end,
  },

  -- Copilot
  { "github/copilot.vim" },

  -- Rainbow CSV
  { "mechatroner/rainbow_csv" },

  -- FZF
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

-- Disable mouse
vim.opt.mouse = ""

-- Filetype detection
vim.cmd [[
  autocmd BufNewFile,BufRead .env.*  setf dosini
]]

-- Clipboard
vim.o.clipboard = 'unnamedplus'
