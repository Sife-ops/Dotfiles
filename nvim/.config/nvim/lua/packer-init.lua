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
    autocmd BufWritePost packer-init.lua source <afile> | PackerSync
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

  use {
    'nvim-treesitter/playground',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
    },
    config = function ()
      require('core.keymap').tree_sitter()
    end
  }

  use {
    'junegunn/fzf.vim',
    requires = {
      'junegunn/fzf'
    },
    config = function() 
      require('core.keymap').fzf()
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        view = {
          side = 'right'
        }
      })
      require('core.keymap').nvim_tree()
    end
  }

  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wellle/targets.vim'

  use {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use {
   'windwp/nvim-autopairs',
   config = function()
     require('nvim-autopairs').setup{}
   end
  }

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

    --config = function()
    --  require('cmp').setup({
    --    -- Completion settings
    --    completion = {
    --      --completeopt = 'menu,menuone,noselect'
    --      keyword_length = 2
    --    },
    --    -- Key mapping
    --    mapping = {
    --      ['<C-n>'] = cmp.mapping.select_next_item(),
    --      ['<C-p>'] = cmp.mapping.select_prev_item(),
    --      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --      ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --      ['<C-Space>'] = cmp.mapping.complete(),
    --      ['<C-e>'] = cmp.mapping.close(),
    --      ['<CR>'] = cmp.mapping.confirm {
    --        behavior = cmp.ConfirmBehavior.Replace,
    --        select = true,
    --      },
    --      -- Tab mapping
    --      ['<Tab>'] = function(fallback)
    --        if cmp.visible() then
    --          cmp.select_next_item()
    --        -- elseif luasnip.expand_or_jumpable() then
    --        --   luasnip.expand_or_jump()
    --        else
    --          fallback()
    --        end
    --      end,
    --      ['<S-Tab>'] = function(fallback)
    --        if cmp.visible() then
    --          cmp.select_prev_item()
    --        -- elseif luasnip.jumpable(-1) then
    --        --   luasnip.jump(-1)
    --        else
    --          fallback()
    --        end
    --      end
    --    },
    --    -- Load sources
    --    sources = {
    --      -- { name = 'nvim_lsp' },
    --      -- { name = 'luasnip' },
    --      { name = 'path' },
    --      { name = 'buffer' },
    --    },
    --  })
    --end

  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup{}
    end
  }

  -- THEME

  use {
     'nvim-lualine/lualine.nvim',
     requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  -- use {
  --   'ellisonleao/gruvbox.nvim',
  --   config = function()
  --     vim.o.background = 'dark'
  --     vim.cmd([[colorscheme gruvbox]])
  --   end
  -- }
  
  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = "storm"
      vim.cmd([[colorscheme tokyonight]])
    end
  }

  -- THEME

  --  -- Indent line
  --  use 'lukas-reineke/indent-blankline.nvim'

  --  -- Tag viewer
  -- use 'preservim/tagbar'

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
