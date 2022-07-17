-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Plugins
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'RyanMillerC/better-vim-tmux-resizer'
  use 'christoomey/vim-tmux-navigator'
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wellle/targets.vim'

  use {
     'feline-nvim/feline.nvim',
     requires = { 'kyazdani42/nvim-web-devicons' },
  }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',
    },
  }

  -- Themes
  use 'Sife-ops/vim-code-dark'
  use 'gruvbox-community/gruvbox'
  use 'navarasu/onedark.nvim'
  use 'tanvirtin/monokai.nvim'
  -- Plug 'Sife-ops/vim-monokai'

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  -- Plug 'neoclide/coc.nvim', {'branch': 'release'}
  -- Plug 'tomasr/molokai'
  -- Plug 'tpope/vim-fugitive'
  -- Plug 'vim-airline/vim-airline'
  -- Plug 'vim-airline/vim-airline-themes'

  --
  --  -- Indent line
  --  use 'lukas-reineke/indent-blankline.nvim'
  --
  --  -- Autopair
  --  use {
  --    'windwp/nvim-autopairs',
  --    config = function()
  --      require('nvim-autopairs').setup{}
  --    end
  --  }
  --
  --  -- Tag viewer
  -- use 'preservim/tagbar'
  --
  --  -- Treesitter interface
  --  use 'nvim-treesitter/nvim-treesitter'
  --
  --  -- Color schemes
  --  use 'navarasu/onedark.nvim'
  --  use 'tanvirtin/monokai.nvim'
  --  use { 'rose-pine/neovim', as = 'rose-pine' }
  --
  --  -- git labels
  --  use {
  --    'lewis6991/gitsigns.nvim',
  --    requires = { 'nvim-lua/plenary.nvim' },
  --    config = function()
  --      require('gitsigns').setup{}
  --    end
  --  }
  --
  --  -- Dashboard (start screen)
  --  use {
  --    'goolord/alpha-nvim',
  --    requires = { 'kyazdani42/nvim-web-devicons' },
  --  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
