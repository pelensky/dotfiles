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
      "--branch=stable", -- latest stable release
      lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "ntpeters/vim-better-whitespace" },
    { "roman/golden-ratio" },
    { "scrooloose/nerdtree" },
    { "bling/vim-airline" },
    { "pivotal/tmux-config" },
    { "editorconfig/editorconfig-vim" },
    { "prettier/vim-prettier" },
    -- Linter
    {
      "dense-analysis/ale",
      config = function()
        vim.g.ale_fixers = {
          ruby = { "rubocop" },
          javascript = { "prettier", "eslint" },
          typescript = { "prettier", "tslint" },
          css = { "prettier" },
          scss = { "prettier", "stylelint" },
          html = { "prettier" }
        }
        vim.g.ale_fix_on_save = 0
      end
    },
    -- Language Specific
    { "sheerun/vim-polyglot" },
    { "evanleck/vim-svelte" },
    -- Colours
    {
      "iammerrick/nova-vim",
      config = function()
        vim.cmd.colorscheme('nova')
      end,
    },
    -- TreeSitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "BufReadPost",
      config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "css", "html", "javascript", "lua", "svelte", "typescript", },
          })
      end,
    },
    -- Comments
    {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup({
          })
        vim.keymap.set('n', '<C-c>', '<Plug>(comment_toggle_linewise_current)')
        vim.keymap.set('x', '<C-c>', '<Plug>(comment_toggle_blockwise_visual)')
      end,
    },
    -- Copilot
    { "github/copilot.vim" },
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
        vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
      end
    },
    -- End of packages
  })

-- Disble mouse
vim.opt.mouse = ""
