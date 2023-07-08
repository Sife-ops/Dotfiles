return {
    "nvim-treesitter/nvim-treesitter",
    -- init = function()
    --     require("core.utils").lazy_load "nvim-treesitter"
    -- end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
        --     return require "plugins.configs.treesitter"
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
        --     dofile(vim.g.base46_cache .. "syntax")
        require("nvim-treesitter.configs").setup(opts)
    end,
}
