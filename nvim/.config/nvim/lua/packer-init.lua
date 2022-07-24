require('packer-install')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

return packer.startup(function(use)

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      use 'nvim-lua/plenary.nvim',
      use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
      use {
        'AckslD/nvim-neoclip.lua',
        -- module = {'telescope'},
        config = function() require('neoclip').setup({}) end
      }
    },
    config = function() 
      require('telescope').setup({
          defaults = {
              cache_picker = {num_pickers = 20},
              layout_strategy = 'flex',
              layout_config = {
                  height = 0.95,
                  width = 0.95,
                  vertical = {preview_height = 0.45},
                  horizontal = {preview_width = 0.50}
              }
          }
      })
      require('telescope').load_extension('fzf')
      require('keymap').telescope()
    end
  }

  use {'raimondi/delimitmate', event = {'InsertEnter'}}

  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup({}) end
  }

  -- use 'mg979/vim-visual-multi'

  -- use {
  --   'karb94/neoscroll.nvim',
  --   config = function() require('neoscroll').setup() end
  -- }

  -- http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
  use 'godlygeek/tabular'

  use 'benmills/vimux'

  use 'chrisbra/NrrwRgn'

  use {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup({}) end
  }

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

  -- use 'tpope/vim-commentary'

  use 'tpope/vim-fugitive'

  use 'tpope/vim-repeat'

  use 'tpope/vim-surround'

  use 'wellle/targets.vim'

  -- --^ fzf
  -- use {
  --   'junegunn/fzf.vim',
  --   requires = { use 'junegunn/fzf' },
  --   config = function()
  --     require('keymap').fzf()
  --   end
  -- }
  -- --$

  --^ git-blame
  use {
    'f-person/git-blame.nvim',
    config = function() 
      vim.cmd([[ let g:gitblame_enabled = 0 ]])
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

  -- --^ nvim-autopairs
  -- use {
  --  'windwp/nvim-autopairs',
  --  config = function()
  --    require('nvim-autopairs').setup({
  --      check_ts = true,
  --    })
  --  end
  -- }
  -- --$

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

  -- use {
  --   'windwp/nvim-ts-autotag',
  --   config = function() require('nvim-ts-autotag').setup({}) end
  -- }

  --^ treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = { 
      use 'p00f/nvim-ts-rainbow',
      use 'nvim-treesitter/playground',
      use {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup({}) end
      }
    },
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

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- vim: fdm=marker fmr=--^,--$
