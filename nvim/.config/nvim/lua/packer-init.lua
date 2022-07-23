require('packer-install')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

keymap = require('keymap')

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'RyanMillerC/better-vim-tmux-resizer'

  use 'christoomey/vim-tmux-navigator'

  use 'tpope/vim-commentary'

  use 'tpope/vim-fugitive'

  use 'tpope/vim-obsession'

  use 'tpope/vim-repeat'

  use 'tpope/vim-surround'

  use 'wellle/targets.vim'

  --^ tokyonight
  use {
    'folke/tokyonight.nvim',
    config = require('config/tokyonight')()
  }
  --$

  --^ vimagit
  use {
    'jreybert/vimagit',
    config = function() keymap.magit() end,
  }
  --$

  --^ fzf
  use {
    'junegunn/fzf.vim',
    requires = { use 'junegunn/fzf' },
    config = function() keymap.fzf() end
  }
  --$

  --^ nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = require('config/nvim-tree')()
  }
  --$

  --^ gitsigns
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
  }
  --$

  --^ nvim-colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }
  --$

  --^ lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = require('config/lualine')()
  }
  --$

  --^ treesitter
  use {
    'nvim-treesitter/playground',
    requires = { use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } },
    config = require('config/treesitter')(),
  }
  --$

  --^ hop
  use {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
      keymap.hop()
    end
  }
  --$

  -- use {
  --   'tveskag/nvim-blame-line',
  --   config = function()
  --     vim.cmd('source $HOME/.config/nvim/core/keymap/nvim-blame.vim')
  --   end,
  -- }

  --   use {
  --    'windwp/nvim-autopairs',
  --    config = function()
  --      require('nvim-autopairs').setup({})
  --    end
  --   }

  --   use 'neovim/nvim-lspconfig'

  --   use {
  --     'hrsh7th/nvim-cmp',
  --     requires = {
  --       'hrsh7th/cmp-nvim-lsp',
  --       'hrsh7th/cmp-path',
  --       'hrsh7th/cmp-buffer',
  --       'saadparwaiz1/cmp_luasnip',
  --       'L3MON4D3/LuaSnip',
  --     },
  --   }

  --  -- Dashboard (start screen)
  --  use {
  --    'goolord/alpha-nvim',
  --    requires = { 'kyazdani42/nvim-web-devicons' },
  --  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- vim: fdm=marker fmr=--^,--$
