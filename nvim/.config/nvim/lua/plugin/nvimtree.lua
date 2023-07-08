return {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function() require("shortcuts").set_shortcuts("nvimtree") end,
    -- opts = function()
    --     return require "plugins.configs.nvimtree"
    -- end,
    config = function(_, opts)
        -- dofile(vim.g.base46_cache .. "nvimtree")
        require("nvim-tree").setup(opts)
        -- vim.g.nvimtree_side = opts.view.side
    end,
}
