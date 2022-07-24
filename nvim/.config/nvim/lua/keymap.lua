function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return {
  core = function() --^
    vim.cmd([[

      let mapleader = " "
      nmap <bs> <space>
      vmap <bs> <space>

      """""""""""""""""""""""""""""""""""""""""""""""""
      "" Splits/Windows
      """""""""""""""""""""""""""""""""""""""""""""""""

      " Only split
      nnoremap ss <C-w>o

      " Tab split
      nnoremap st :tab split<cr>

      " Vertical split
      nnoremap sv <C-w>v

      " Close split
      nnoremap sc <C-w>c

     " Move between windows easily
      nnoremap sk <C-w><C-k>
      nnoremap sj <C-w><C-j>
      nnoremap sl <C-w><C-l>
      nnoremap sh <C-w><C-h>

      " Move windows easily
      nnoremap <C-w>j <C-w>J
      nnoremap <C-w>k <C-w>K
      nnoremap <C-w>l <C-w>L
      nnoremap <C-w>h <C-w>H

      inoremap jk <esc>
      nnoremap <leader>q :qa!<cr>
      " map('n', '<leader>sa', 'ggVG')
      nnoremap <leader>so :source $HOME/.config/nvim/init.lua<cr>, { silent = false } -- bs leader wtf?
      nnoremap <leader>w :wa<cr>

      nnoremap <leader>z :wqa!<cr>
      nnoremap Y yy
      vnoremap <leader>@ :norm @q<cr>
      vnoremap <leader>r :!rev<cr>
      vnoremap <leader>s :sort<cr>

      nnoremap <leader>n :tabn<cr>
      nnoremap <leader>p :tabp<cr>
      nnoremap <leader>xb :bdelete<cr>
      nnoremap <leader>xt :tabc<cr>

      nnoremap <leader>mch :set cursorcolumn!<cr>
      nnoremap <leader>mdln ivim: fdm= fmr=
      nnoremap <leader>mhl :set hlsearch!<cr>
      nnoremap <leader>mln :set number!<cr>
      nnoremap <leader>mwr :set wrap!<cr>

      nnoremap # :keepjumps normal! mi#`i<cr>
      nnoremap * :keepjumps normal! mi*`i<cr>
      nnoremap N Nzzzv
      nnoremap n nzzzv
      xnoremap # :call GetSelectedText()<cr>?<C-R>=@/<cr><cr>
      xnoremap * :call GetSelectedText()<cr>/<C-R>=@/<cr><cr>

    ]])
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
