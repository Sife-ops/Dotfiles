return {
    "neovim/nvim-lspconfig",
    config = function()
        require("shortcuts").set_shortcuts("lspconfig")
        require("lspconfig").lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        })
    end,
}
