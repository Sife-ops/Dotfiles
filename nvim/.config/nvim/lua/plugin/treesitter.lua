return {
    "nvim-treesitter/nvim-treesitter",
    -- cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    init = function()
        vim.opt.foldmethod = "expr" -- todo: move to option.lua?
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("UserTSConfig", { clear = true }),
            command = "normal zR",
        })
    end,
    opts = function()
        return {
            ensure_installed = { "lua" },

            highlight = {
                enable = true,
                use_languagetree = true,
            },

            indent = {
                enable = true
            },
        }
    end,
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
