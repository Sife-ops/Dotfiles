return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    init = function()
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
    opts = function()
        return {
            -- ensure_installed = { "lua-language-server" }, -- not an option from mason.nvim
            PATH = "skip"
        }
    end,
    config = function(_, opts)
        -- dofile(vim.g.base46_cache .. "mason")
        require("mason").setup(opts)

        -- custom nvchad cmd to install all mason binaries listed
        -- vim.api.nvim_create_user_command("MasonInstallAll", function()
        --     vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        -- end, {})

        -- vim.g.mason_binaries_list = opts.ensure_installed
    end,
}
