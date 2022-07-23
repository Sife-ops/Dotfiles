require('nvim-tree').setup({
  -- view = {
  --   side = 'right',
  -- },
  filters = {
    dotfiles = false,
  },
})
require('keymap').nvim_tree()

