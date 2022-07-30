local lspconfig = require('lspconfig')
local utility = require('sife-ops/utility')

local opts = { noremap = true, silent = false }

local on_attach = function(_, bufnr)
  local set = vim.api.nvim_buf_set_keymap

  set(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  set(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  set(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  set(bufnr, 'n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  set(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  set(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  set(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  set(bufnr, 'n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  set(bufnr, 'n', 'glQ', '<cmd>lua vim.diagnostic.setqflist()<cr>', opts)
  set(bufnr, 'n', 'gla', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  set(bufnr, 'n', 'gld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  set(bufnr, 'n', 'glf', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  set(bufnr, 'n', 'glq', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
  set(bufnr, 'n', 'glr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  set(bufnr, 'n', 'glw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)
  set(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  set(bufnr, 'n', 'gs', '<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>', opts)
  set(bufnr, 'n', 'gt', '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>', opts)
  set(bufnr, 'v', 'ga', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.tsserver.setup {
  cmd = {
    utility.lsp_dir .. '/tsserver/node_modules/.bin/typescript-language-server', '--stdio'
  },
  capabilities = capabilities,
  -- on_attach = on_attach,
  on_attach = function(client, bufnr)
    -- client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  -- flags = lsp_flags,
  flags = { debounce_text_changes = 150 }
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
lspconfig.sumneko_lua.setup {
  on_attach = function(client, bufnr)
    -- client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        path = runtime_path
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        -- globals = {'vim'},
        globals = { 'vim', 'use' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.gopls.setup({
    cmd = {utility.lsp_dir .. '/gopls/gopls'},
    capabilities = capabilities,
    on_attach = on_attach
})

