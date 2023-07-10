return {
    "williamboman/mason.nvim",
    -- cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    init = function()
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
    opts = {
        PATH = "skip"
    },
    config = function(_, opts)
        require("mason").setup(opts)
    end,
}
