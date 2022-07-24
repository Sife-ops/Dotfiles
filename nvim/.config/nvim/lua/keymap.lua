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
    map('n', '<leader>q', ':qa!<cr>')
    map('n', '<leader>sa', 'ggVG')
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

  end,

  git_blame = function()
    map('n', '<leader>mbl', ':GitBlameToggle<cr>')
  end,

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

  telescope = function()
    vim.cmd([[
      nnoremap ;/    :lua require('telescope.builtin').search_history()<cr>
      nnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
      xnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
      nnoremap ;a    :lua require('telescope.builtin').autocommands()<cr>
      nnoremap ;b    :lua require('telescope.builtin').buffers({sort_mru=true})<cr>
      nnoremap ;B    :lua require('telescope.builtin').builtin()<cr>
      nnoremap ;c    :lua require('telescope.builtin').commands()<cr>
      nnoremap ;f    :lua require('telescope.builtin').find_files({hidden=true})<cr>
      nnoremap ;gc   :lua require('telescope.builtin').git_bcommits()<cr>
      nnoremap ;gC   :lua require('telescope.builtin').git_commits()<cr>
      nnoremap ;gb   :lua require('telescope.builtin').git_branches()<cr>
      nnoremap ;gf   :lua require('telescope.builtin').git_files()<cr>
      nnoremap ;gg   :lua require('telescope.builtin').live_grep()<cr>
      nnoremap ;gs   :lua require('telescope.builtin').grep_string({use_regex=true, search=''})<left><left><left>
      nnoremap ;gS   :lua require('telescope.builtin').git_stash()<cr>
      nnoremap ;h    :lua require('telescope.builtin').help_tags()<cr>
      nnoremap ;j    :lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>
      nnoremap ;k    :lua require('telescope.builtin').keymaps()<cr>
      nnoremap ;ll   :lua require('telescope.builtin').loclist()<cr>
      nnoremap ;la   :lua require('telescope.builtin').lsp_code_actions()<cr>
      " TODO: Figure out why this is not working with visual selection
      " vnoremap ;la   :lua require('telescope.builtin').lsp_range_code_actions()<cr>
      nnoremap ;ld   :lua require('telescope.builtin').diagnostics({bufnr=0})<cr>
      nnoremap ;lm   :lua require('telescope.builtin').man_pages()<cr>
      nnoremap ;ls   :lua require('telescope.builtin').lsp_document_symbols()<cr>
      nnoremap ;lD   :lua require('telescope.builtin').diagnostics()<cr>
      nnoremap ;lS   :lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>
      nnoremap ;m    :lua require('telescope.builtin').marks()<cr>
      nnoremap ;n    :lua require('telescope').extensions.neoclip.default()<cr>
      nnoremap ;of   :lua require('telescope.builtin').oldfiles()<cr>
      nnoremap ;p    :lua require('telescope.builtin').pickers()<cr>
      nnoremap ;q    :lua require('telescope.builtin').quickfix()<cr>
      nnoremap ;r    :lua require('telescope.builtin').resume()<cr>
      nnoremap ;R    :lua require('telescope.builtin').registers()<cr>
      nnoremap ;s    :lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>
      nnoremap ;t    :lua require('telescope.builtin').treesitter()<cr>
      nnoremap ;vf   :lua require('telescope.builtin').filetypes()<cr>
      nnoremap ;vo   :lua require('telescope.builtin').vim_options()<cr>
      nnoremap ;w    :Telescope grep_string<cr>
      xnoremap ;w    :call GetSelectedText()<cr>:Telescope grep_string additional_args={'-F'} use_regex=false search=<C-R>=@/<cr><cr>
    ]])
  end,

  treesitter = function()
    map('n', '<leader>t', ':TSPlaygroundToggle<cr>')
  end,
}

