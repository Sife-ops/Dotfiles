return {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
        require("shortcuts").set_shortcuts("nvimtree")
    end,
    opts = {
        filters = {
            git_ignored = false,
        },
        view = {
            side = "right"
        }
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        -- vim.g.nvimtree_side = opts.view.side
    end,
}
