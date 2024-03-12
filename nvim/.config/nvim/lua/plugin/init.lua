return {
    "nvim-lua/plenary.nvim",
    require("plugin.treesitter"),
    {
        -- https://github.com/apple/pkl-neovim/pull/5
        "jayadamsmorgan/pkl-neovim",
        lazy = true,
        event = "BufReadPre *.pkl",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        build = function()
            vim.cmd("TSInstall! pkl")
        end,
    },
    require("plugin.lsp"),
    require("plugin.telescope"),
    require("plugin.nvimtree"),
    require("plugin.mason"),
    require("plugin.onedark"),
    require("plugin.comment"),
    require("plugin.surround"),
    require("plugin.gitsigns"),
}
