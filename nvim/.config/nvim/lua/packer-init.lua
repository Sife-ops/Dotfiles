require('packer-install')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

return packer.startup(function(use)

  use 'sirver/ultisnips'

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'}
    },
    config = function()
      require('config/nvim-cmp')
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('config/nvim-lspconfig')
    end,
  }

  use 'RyanMillerC/better-vim-tmux-resizer'

  use 'christoomey/vim-tmux-navigator'

  use 'tpope/vim-commentary'

  use 'tpope/vim-fugitive'

  use 'tpope/vim-repeat'

  use 'tpope/vim-surround'

  use 'wellle/targets.vim'

  --^ fzf
  use {
    'junegunn/fzf.vim',
    requires = { use 'junegunn/fzf' },
    config = function()
      require('keymap').fzf()
    end
  }
  --$

  --^ git-blame
  use {
    'f-person/git-blame.nvim',
    config = function() 
      require('keymap').git_blame() 
    end,
  }
  --$

  --^ gitsigns
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  }
  --$

  --^ hop
  use {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
      require('keymap').hop()
    end
  }
  --$

  --^ lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('config/lualine')
    end,
  }
  --$

  --^ nvim-colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }
  --$

  --^ nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('config/nvim-tree')
    end,
  }
  --$

  --^ obsession
  use {
    'tpope/vim-obsession',
    config = function()
      require('keymap').obsession()
    end,
  }
  --$

  --^ packer
  use {
    'wbthomason/packer.nvim',
    config = function()
      require('keymap').packer()
    end,
  }
  --$

  --^ tokyonight
  use {
    'folke/tokyonight.nvim',
    config = function()
      require('config/tokyonight')
    end,
  }
  --$

  --^ treesitter
  use {
    'nvim-treesitter/playground',
    requires = { use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } },
    config = function()
      require('config/treesitter')
    end,
  }
  --$

  --^ vimagit
  use {
    'jreybert/vimagit',
    config = function()
      require('keymap').magit()
    end,
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
