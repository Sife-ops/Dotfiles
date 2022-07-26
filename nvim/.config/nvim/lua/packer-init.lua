require('packer-install')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

return packer.startup(function(use)

  use 'RyanMillerC/better-vim-tmux-resizer'

  use 'benmills/vimux'

  use 'brooth/far.vim'

  use 'chrisbra/NrrwRgn'

  use 'christoomey/vim-tmux-navigator'

  use 'godlygeek/tabular' -- http://vimcasts.org/episodes/aligning-text-with-tabular-vim/

  use 'jreybert/vimagit'

  use 'kana/vim-textobj-entire'

  use 'kana/vim-textobj-user'

  use 'hrsh7th/vim-vsnip'

  -- use 'sirver/ultisnips'

  use 'tpope/vim-fugitive'

  use 'tpope/vim-obsession'

  use 'tpope/vim-repeat'

  use 'tpope/vim-surround'

  use 'wbthomason/packer.nvim'

  use 'wellle/targets.vim'

  use { 'raimondi/delimitmate', event = { 'InsertEnter' } }

  --^ git-blame
  use {
    'f-person/git-blame.nvim',
    config = function() vim.cmd([[ let g:gitblame_enabled = 0 ]]) end,
  }
  --$

  --^ gitsigns
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
  }
  --$

  --^ hop
  use {
    'phaazon/hop.nvim',
    config = function() require('hop').setup { keys = 'etovxqpdygfblzhckisuran' } end
  }
  --$

  --^ lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('config/lualine') end,
  }
  --$

  --^ nvim-colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }
  --$

  --^ nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('config/nvim-tree') end,
  }
  --$

  --^ tokyonight
  use {
    'folke/tokyonight.nvim',
    config = function() require('config/tokyonight') end,
  }
  --$

  --^ comment
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup({}) end
  }
  --$

  --^ fidget
  use {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup({}) end
  }
  --$

  --^ harpoon
  use {
    'ThePrimeagen/harpoon',
    requires = { 'nvim-lua/plenary.nvim' },
    -- module = {'harpoon.mark', 'harpoon.ui'},
    config = function()
      require('harpoon').setup({
        menu = { width = vim.api.nvim_win_get_width(0) - 4 }
      })
    end
  }
  --$

  --^ telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      use 'nvim-lua/plenary.nvim',
      use 'BurntSushi/ripgrep',
      use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      use {
        'AckslD/nvim-neoclip.lua',
        -- module = {'telescope'},
        config = function() require('neoclip').setup({}) end
      }
    },
    config = function()
      require('telescope').setup({
        defaults = {
          cache_picker = { num_pickers = 20 },
          layout_strategy = 'flex',
          layout_config = {
            height = 0.95,
            width = 0.95,
            vertical = { preview_height = 0.45 },
            horizontal = { preview_width = 0.50 }
          }
        }
      })
      require('telescope').load_extension('fzf')
    end
  }
  --$

  --^ vim-visual-multi
  use {
    'mg979/vim-visual-multi',
    config = function()
      vim.cmd([[
        let g:VM_theme = 'neon'
        let g:VM_silent_exit = v:true
      ]])
    end,
  }
  --$

  --^ nvim-cmp
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- { 'quangnguyen30192/cmp-nvim-ultisnips' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-path' }
    },
    config = function() require('config/nvim-cmp') end,
  }
  --$

  --^ nvim-lspconfig
  use {
    'neovim/nvim-lspconfig',
    config = function() require('config/nvim-lspconfig') end,
  }
  --$

  --^ nvim-lsp-installer
  use {
    "williamboman/nvim-lsp-installer",
    config = function()
      require("nvim-lsp-installer").setup({
        automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
        -- ui = {
        --     icons = {
        --         server_installed = "✓",
        --         server_pending = "➜",
        --         server_uninstalled = "✗"
        --     }
        -- }
      })
    end
  }
  --$

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
    config = function() require('config/treesitter') end,
  }
  --$

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end

end)

-- vim: fdm=marker fmr=--^,--$
