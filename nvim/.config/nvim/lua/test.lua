function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return {
  core = function()
    vim.g.mapleader = ' '
    vim.api.nvim_set_keymap('n', '<bs>', '<space>', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('v', '<bs>', '<space>', {noremap = false, silent = true})

    map('i', 'jk', '<esc>')
    map('n', '<leader>mch', ':set cursorline! cursorcolumn!<cr>')
    map('n', '<leader>mdln', 'ivim: ft= fdm= fmr=')
    map('n', '<leader>mhl', ':set hlsearch!<cr>')
    map('n', '<leader>mln', ':set number!<cr>')
    map('n', '<leader>mwr', ':set wrap!<cr>')
    map('n', '<leader>n', ':tabn<cr>')
    map('n', '<leader>p', ':tabp<cr>')
    map('n', '<leader>q', ':qa!<cr>')
    map('n', '<leader>sa', 'ggVG')
    map('n', '<leader>so', ':source ~/.config/nvim/init.lua<cr>')
    map('n', '<leader>w', ':wa<cr>')
    map('n', '<leader>xb', ':bdelete<cr>')
    map('n', '<leader>xt', ':tabc<cr>')
    map('n', '<leader>z', ':wqa!<cr>')
    map('n', 'Y', 'yy')
    map('v', '<leader>@', ':norm @q<cr>')
    map('v', '<leader>r', ':!rev<cr>')
    map('v', '<leader>s', ':sort<cr>')
  end,

  fzf = function()
    map('nnoremap', '<C-f>', ':exe ":cd " . system("git rev-parse --show-toplevel")<cr>:Rg<cr>')
    map('nnoremap', '<C-p>', ':GFiles<cr>')
    map('nnoremap', '<leader>b', ':Buffers<cr>')
  end,

  hop = function()
    map('n', '<leader><leader>', "<cmd>lua require'hop'.hint_words()<cr>", {})
  end,

  magit = function()
    map('nnoremap', '<leader>mG', ':MagitOnly<cr>')
    map('nnoremap', '<leader>mg', ':Magit<cr>')
  end,

  nvim_tree = function()
    map('nnoremap', '<leader>e', ':NvimTreeFindFile<cr>')
  end,

  treesitter = function()
    map('nnoremap', '<leader>t', ':TSPlaygroundToggle<cr>')
  end,
}

