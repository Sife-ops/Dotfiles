require('nvim-treesitter.configs').setup {
  -- ensure_installed = 'all',
  ensure_installed = {'lua', 'typescript', 'javascript'},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require('keymap').treesitter()

