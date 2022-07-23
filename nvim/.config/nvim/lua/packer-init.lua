require('packer-install')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

local keymap = require('test')

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

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = "night"
      vim.cmd('colorscheme tokyonight')
    end
  }

  use {
    'jreybert/vimagit',
    config = function()
      -- vim.cmd('source $HOME/.config/nvim/core/keymap/magit.vim')
      keymap.magit()
    end,
  }

  use {
    'junegunn/fzf.vim',
    requires = {
      use 'junegunn/fzf'
    },
    config = function()
      -- vim.cmd('source $HOME/.config/nvim/core/keymap/fzf.vim')
      keymap.fzf()
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        -- view = {
        --   side = 'right',
        -- },
        filters = {
          dotfiles = false,
        },
      })
      -- vim.cmd('source $HOME/.config/nvim/core/keymap/nvim-tree.vim')
      keymap.nvim_tree()
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight'
        }
      }
    end
  }

  use {
    'nvim-treesitter/playground',
    requires = {
      use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
      },
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = {
          enable = true,
        },
      }
      -- vim.cmd('source $HOME/.config/nvim/core/keymap/treesitter.vim')
      keymap.treesitter()
    end
  }

  use {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
      -- vim.cmd('source $HOME/.config/nvim/core/keymap/hop.vim')
      keymap.hop()
    end
  }

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

