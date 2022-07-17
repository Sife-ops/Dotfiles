local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<bs>', '<space>', {noremap = false, silent = true})
vim.api.nvim_set_keymap('v', '<bs>', '<space>', {noremap = false, silent = true})

map('i', 'jk', '<esc>')
map('n', '<leader>mch', ':set cursorline! cursorcolumn!<cr>')
map('n', '<leader>mhl', ':set hlsearch!<cr>')
map('n', '<leader>mln', ':set number!<cr>')
map('n', '<leader>mwr', ':set wrap!<cr>')
map('n', '<leader>q', ':qa!<cr>')
map('n', '<leader>w', ':wa<cr>')
map('n', '<leader>z', ':wqa!<cr>')
map('n', 'Y', 'yy')
map('v', '<leader>@', ':norm @q<cr>')
map('v', '<leader>r', ':!rev<cr>')
map('v', '<leader>s', ':sort<cr>')

-- NvimTree
-- map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
-- map('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
-- map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file
map('n', '<leader>e', ':NvimTreeToggle<CR>')            -- open/close

-- FzF
map('n', '<C-f>', ':exe ":cd " . system("git rev-parse --show-toplevel")<cr>:Rg<cr>')
map('n', '<C-p>', ':GFiles<cr>')
map('n', '<leader>b', ':Buffers<cr>')

