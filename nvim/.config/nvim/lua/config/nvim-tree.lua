require('nvim-tree').setup({
  -- view = {
  --   side = 'right',
  -- },
  open_on_setup = true,
  filters = {
    dotfiles = false,
  },
  git = {
    ignore = false,
  }
})
require('keymap').nvim_tree()

