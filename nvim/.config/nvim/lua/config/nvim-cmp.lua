local cmp = require('cmp')
local cmp_ultisnips = require('cmp_nvim_ultisnips.mappings')

cmp.setup({

  experimental = {ghost_text = true},

  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp', preselect = true },
    { name = 'ultisnips', preselect = true },
    { 
      name = 'buffer' ,
      preselect = true,
      max_item_count = 20,
      option = { keyword_pattern = [[\k\k\k\+]] }
    },
    { name = 'path' },
  }),

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({

    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i'}),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({select = true}), {'i'}),

    -- sucks
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

  }),

})

-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on(
--   'confirm_done',
--   cmp_autopairs.on_confirm_done()
-- )

