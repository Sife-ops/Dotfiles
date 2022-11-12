require('sife-ops/config/packer-init')

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

return packer.startup(function(use)

  --^ theme
  -- use "nanozuki/tabby.nvim"
  use 'folke/tokyonight.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  --$

  --^ miscellaneous
  use 'RyanMillerC/better-vim-tmux-resizer'
  -- use 'benmills/vimux'
  -- use 'brooth/far.vim'
  -- use 'chrisbra/NrrwRgn'
  use 'christoomey/vim-tmux-navigator'
  -- use 'godlygeek/tabular' -- http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
  -- use 'hrsh7th/vim-vsnip'
  use 'jreybert/vimagit'
  use 'kana/vim-textobj-entire'
  use 'kana/vim-textobj-user'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wbthomason/packer.nvim'
  use 'wellle/targets.vim'
  -- use { 'raimondi/delimitmate', event = { 'InsertEnter' } }
  --$

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

  --^ nvim-colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }
  --$

  --^ nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        filters = { dotfiles = false, },
        git = { ignore = false, },
        actions = {
          change_dir = { global = true }
        },
        update_cwd = true,
        -- view = {mappings = {custom_only = true, list = list}},
        renderer = {
          group_empty = true,
          indent_markers = { enable = true },
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = false
            }
          }
        }
      })
    end
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

  --^ indent-blankline
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
        show_end_of_line = true,
      }
    end
  }
  --$

  --^ harpoon
  use {
    'ThePrimeagen/harpoon',
    requires = { 'nvim-lua/plenary.nvim' },
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
        config = function() require('neoclip').setup({}) end
      },
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

  -- --^ nvim-cmp
  -- use {
  --   'hrsh7th/nvim-cmp',
  --   requires = {
  --     -- { 'quangnguyen30192/cmp-nvim-ultisnips' },
  --     { 'hrsh7th/cmp-vsnip' },
  --     { 'hrsh7th/cmp-buffer' },
  --     { 'hrsh7th/cmp-nvim-lsp' },
  --     { 'hrsh7th/cmp-path' }
  --   },
  --   config = function()
  --     local cmp = require('cmp')
  --     cmp.setup({
  --       experimental = { ghost_text = true },

  --       snippet = {
  --         expand = function(args)
  --           -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  --           vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
  --         end,
  --       },

  --       sources = cmp.config.sources({
  --         { name = 'nvim_lsp', preselect = true },
  --         { name = 'vsnip' }, -- For vsnip users.
  --         -- { name = 'ultisnips', preselect = true },
  --         {
  --           name = 'buffer',
  --           preselect = true,
  --           max_item_count = 20,
  --           option = { keyword_pattern = [[\k\k\k\+]] }
  --         },
  --         { name = 'path' },
  --       }),

  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },

  --       mapping = cmp.mapping.preset.insert({
  --         ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i' }),
  --         ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i' }),

  --         -- sucks
  --         ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --       }),
  --     })
  --   end
  -- }
  -- --$

  -- --^ nvim-lspconfig
  -- use {
  --   'neovim/nvim-lspconfig',
  --   config = function() require('sife-ops/nvim-lspconfig') end,
  -- }
  -- --$

  -- --^ nvim-lsp-installer
  -- use {
  --   "williamboman/nvim-lsp-installer",
  --   config = function()
  --     require("nvim-lsp-installer").setup({
  --       automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  --       -- ui = {
  --       --     icons = {
  --       --         server_installed = "✓",
  --       --         server_pending = "➜",
  --       --         server_uninstalled = "✗"
  --       --     }
  --       -- }
  --     })
  --   end
  -- }
  -- --$

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
      },
      use {
        "folke/twilight.nvim",
        config = function()
          require("twilight").setup({})
        end
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        -- ensure_installed = 'all',
        ensure_installed = { 'lua', 'typescript', 'javascript' },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        },
        autotag = {
          enable = true,
        },
      }
    end
  }
  --$

  -- Automatically set up your configuration after cloning packer.nvim
  if Packer_bootstrap then
    require('packer').sync()
  end

end)

-- vim: fdm=marker fmr=--^,--$
