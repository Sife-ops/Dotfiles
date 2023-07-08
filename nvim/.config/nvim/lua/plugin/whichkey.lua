return {
    "folke/which-key.nvim",
    -- keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
    keys = { "<leader>" },
    init = function()
        -- require("shortcuts").set_shortcuts("whichkey")
    end,
    config = function(_, opts)
        require("which-key").setup(opts)
    end,
}
