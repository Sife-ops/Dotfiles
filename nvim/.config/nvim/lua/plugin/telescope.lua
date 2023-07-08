-- local set_shortcuts = require("shortcuts")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Telescope",
    init = function() require("shortcuts").set_shortcuts("telescope") end,
    -- opts = function()
    --     return require "plugins.configs.telescope"
    -- end,
    -- config = function(_, opts)
    --     dofile(vim.g.base46_cache .. "telescope")
    --     local telescope = require "telescope"
    --     telescope.setup(opts)

    --     -- load extensions
    --     for _, ext in ipairs(opts.extensions_list) do
    --         telescope.load_extension(ext)
    --     end
    -- end,
}
