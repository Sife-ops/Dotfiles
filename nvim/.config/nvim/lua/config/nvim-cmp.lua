local cmp = require'cmp'
-- local cmp_ultisnips = require("cmp_nvim_ultisnips.mappings")

cmp.setup({
  experimental = {ghost_text = true},
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },

  mapping = cmp.mapping.preset.insert({
    -- ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<C-e>'] = cmp.mapping.abort(),
    -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i'}),
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({select = true}), {'i'}),

    -- ['<M-n>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),
    -- ['<M-p>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),

    ['<C-n>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
        else
            fallback()
        end
    end, {'i'}),
    ['<C-p>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
        else
            fallback()
        end
    end, {'i'}),

    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),

    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),

  }),

  -- sources = cmp.config.sources({
  --   { name = 'nvim_lsp' },
  --   { name = 'ultisnips' },
  -- }, {
  --   { name = 'buffer' },
  -- })

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
  })

  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- },

})

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- -- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }
