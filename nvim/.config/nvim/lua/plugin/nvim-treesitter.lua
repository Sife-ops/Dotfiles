local status_ok, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

nvim_treesitter.setup {
  -- A list of parser names, or "all"
  -- ensure_installed = { 'bash', 'c', 'cpp', 'css', 'html', 'javascript', 'json', 'lua', 'python', 'typescript', 'vim' }, 
  ensure_installed = 'all',
  sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true, -- `false` will disable the whole extension
    disable = {''},
  },
}
