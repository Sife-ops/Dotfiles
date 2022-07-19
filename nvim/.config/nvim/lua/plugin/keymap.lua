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

-- general
map('i', 'jk', '<esc>')
map('n', '<leader>R', ':edit!<cr>')
map('n', '<leader>mch', ':set cursorline! cursorcolumn!<cr>')
map('n', '<leader>mhl', ':set hlsearch!<cr>')
map('n', '<leader>mln', ':set number!<cr>')
map('n', '<leader>mwr', ':set wrap!<cr>')
map('n', '<leader>n', ':tabn<cr>')
map('n', '<leader>p', ':tabp<cr>')
map('n', '<leader>q', ':qa!<cr>')
map('n', '<leader>w', ':wa<cr>')
map('n', '<leader>z', ':wqa!<cr>')
map('n', 'Y', 'yy')
map('v', '<leader>@', ':norm @q<cr>')
map('v', '<leader>r', ':!rev<cr>')
map('v', '<leader>s', ':sort<cr>')

-- fzf
map('n', '<C-f>', ':exe ":cd " . system("git rev-parse --show-toplevel")<cr>:Rg<cr>')
map('n', '<C-p>', ':GFiles<cr>')
map('n', '<leader>b', ':Buffers<cr>')

-- hop
map('n', '<leader><leader>', "<cmd>lua require'hop'.hint_words()<cr>", {})

-- nvim-tree
map('n', '<leader>e', ':NvimTreeFindFile<CR>')

-- treesitter
map('n', '<leader>t', ':TSPlaygroundToggle<cr>')
