return {
    "nvim-treesitter/nvim-treesitter",
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
        return {
            ensure_installed = { "lua" },

            highlight = {
                enable = true,
                use_languagetree = true,
            },

            indent = { enable = true },
        }
    end,
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
