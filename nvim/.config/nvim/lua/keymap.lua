function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return {
  core = function() --^

    vim.g.mapleader = ' '
    vim.api.nvim_set_keymap('n', '<bs>', '<space>', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('v', '<bs>', '<space>', {noremap = false, silent = true})

    map('i', 'jk', '<esc>')
    map('n', '<leader>q', ':qa!<cr>')
    -- map('n', '<leader>sa', 'ggVG')
    map('n', '<leader>so', ':source $HOME/.config/nvim/init.lua<cr>', { silent = false }) -- bs leader wtf?
    map('n', '<leader>w', ':wa<cr>')
    map('n', '<leader>z', ':wqa!<cr>')
    map('n', 'Y', 'yy')
    map('v', '<leader>@', ':norm @q<cr>')
    map('v', '<leader>r', ':!rev<cr>')
    map('v', '<leader>s', ':sort<cr>')

    map('n', '<leader>n', ':tabn<cr>')
    map('n', '<leader>p', ':tabp<cr>')
    map('n', '<leader>xb', ':bdelete<cr>')
    map('n', '<leader>xt', ':tabc<cr>')

    map('n', '<leader>mch', ':set cursorcolumn!<cr>')
    map('n', '<leader>mdln', 'ivim: fdm= fmr=')
    map('n', '<leader>mhl', ':set hlsearch!<cr>')
    map('n', '<leader>mln', ':set number!<cr>')
    map('n', '<leader>mwr', ':set wrap!<cr>')

    map('n', '#', ':keepjumps normal! mi#`i<cr>')
    map('n', '*', ':keepjumps normal! mi*`i<cr>')
    map('n', 'N', 'Nzzzv')
    map('n', 'n', 'nzzzv')
    map('x', '#', ':call GetSelectedText()<cr>?<C-R>=@/<cr><cr>')
    map('x', '*', ':call GetSelectedText()<cr>/<C-R>=@/<cr><cr>')

  end, --$

  git_blame = function()
    map('n', '<leader>mbl', ':GitBlameToggle<cr>')
  end,

  harpoon = function() --^
    vim.cmd([[
      nnoremap <leader>sa :lua require("harpoon.mark").add_file()<cr>
      nnoremap <leader>sA :lua require("harpoon.ui").toggle_quick_menu()<cr>
      nnoremap <leader>sm :lua require("harpoon.ui").nav_file(1)<cr>
      nnoremap <leader>s, :lua require("harpoon.ui").nav_file(2)<cr>
      nnoremap <leader>s. :lua require("harpoon.ui").nav_file(3)<cr>
      nnoremap <leader>sj :lua require("harpoon.ui").nav_file(4)<cr>
      nnoremap <leader>sk :lua require("harpoon.ui").nav_file(5)<cr>
      nnoremap <leader>sl :lua require("harpoon.ui").nav_file(6)<cr>
      nnoremap <leader>su :lua require("harpoon.ui").nav_file(7)<cr>
      nnoremap <leader>si :lua require("harpoon.ui").nav_file(8)<cr>
      nnoremap <leader>so :lua require("harpoon.ui").nav_file(9)<cr>
    ]])
  end, --$

  hop = function()
    map('n', '<leader><leader>', "<cmd>lua require'hop'.hint_words()<cr>", {})
  end,

  magit = function()
    map('n', '<leader>mG', ':MagitOnly<cr>')
    map('n', '<leader>mg', ':Magit<cr>')
  end,

  nvim_tree = function()
    map('n', '<leader>e', ':NvimTreeFindFile<cr>')
  end,

  obsession = function()
    map('n', '<leader>mo', ':Obsession $PWD/Session.vim', { silent = false })
  end,

  packer = function()
    map('n', '<leader>ss', ':source $HOME/.config/nvim/lua/packer-init.lua | PackerSync<cr>')
  end,

  telescope = function() --^
    -- todo: globar text search
    -- todo: replace all 'map' calls
    vim.cmd([[
      nnoremap <leader>;/    :lua require('telescope.builtin').search_history()<cr>
      nnoremap <leader>;;    :lua require('telescope.builtin').command_history()<cr>
      xnoremap <leader>;;    :lua require('telescope.builtin').command_history()<cr>
      nnoremap <leader>;a    :lua require('telescope.builtin').autocommands()<cr>
      nnoremap <leader>;b    :lua require('telescope.builtin').buffers({sort_mru=true})<cr>
      nnoremap <leader>;B    :lua require('telescope.builtin').builtin()<cr>
      nnoremap <leader>;c    :lua require('telescope.builtin').commands()<cr>
      nnoremap <leader>;f    :lua require('telescope.builtin').find_files({hidden=true})<cr>
      nnoremap <leader>;gc   :lua require('telescope.builtin').git_bcommits()<cr>
      nnoremap <leader>;gC   :lua require('telescope.builtin').git_commits()<cr>
      nnoremap <leader>;gb   :lua require('telescope.builtin').git_branches()<cr>
      nnoremap <leader>;gf   :lua require('telescope.builtin').git_files()<cr>
      nnoremap <leader>;gg   :lua require('telescope.builtin').live_grep()<cr>
      nnoremap <leader>;gs   :lua require('telescope.builtin').grep_string({use_regex=true, search=''})<left><left><left>
      nnoremap <leader>;gS   :lua require('telescope.builtin').git_stash()<cr>
      nnoremap <leader>;h    :lua require('telescope.builtin').help_tags()<cr>
      nnoremap <leader>;j    :lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>
      nnoremap <leader>;k    :lua require('telescope.builtin').keymaps()<cr>
      nnoremap <leader>;ll   :lua require('telescope.builtin').loclist()<cr>
      nnoremap <leader>;la   :lua require('telescope.builtin').lsp_code_actions()<cr>
      " TODO: Figure out why this is not working with visual selection
      " vnoremap ;la   :lua require('telescope.builtin').lsp_range_code_actions()<cr>
      nnoremap <leader>;ld   :lua require('telescope.builtin').diagnostics({bufnr=0})<cr>
      nnoremap <leader>;lm   :lua require('telescope.builtin').man_pages()<cr>
      nnoremap <leader>;ls   :lua require('telescope.builtin').lsp_document_symbols()<cr>
      nnoremap <leader>;lD   :lua require('telescope.builtin').diagnostics()<cr>
      nnoremap <leader>;lS   :lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>
      nnoremap <leader>;m    :lua require('telescope.builtin').marks()<cr>
      nnoremap <leader>;n    :lua require('telescope').extensions.neoclip.default()<cr>
      nnoremap <leader>;of   :lua require('telescope.builtin').oldfiles()<cr>
      nnoremap <leader>;p    :lua require('telescope.builtin').pickers()<cr>
      nnoremap <leader>;q    :lua require('telescope.builtin').quickfix()<cr>
      nnoremap <leader>;r    :lua require('telescope.builtin').resume()<cr>
      nnoremap <leader>;R    :lua require('telescope.builtin').registers()<cr>
      nnoremap <leader>;s    :lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>
      nnoremap <leader>;t    :lua require('telescope.builtin').treesitter()<cr>
      nnoremap <leader>;vf   :lua require('telescope.builtin').filetypes()<cr>
      nnoremap <leader>;vo   :lua require('telescope.builtin').vim_options()<cr>
      nnoremap <leader>;w    :Telescope grep_string<cr>
      xnoremap <leader>;w    :call GetSelectedText()<cr>:Telescope grep_string additional_args={'-F'} use_regex=false search=<C-R>=@/<cr><cr>
    ]])
  end, --$

  treesitter = function()
    map('n', '<leader>t', ':TSPlaygroundToggle<cr>')
  end,
}

-- vim: fdm=marker fmr=--^,--$
