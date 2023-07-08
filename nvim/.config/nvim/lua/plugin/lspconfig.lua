return {
    "neovim/nvim-lspconfig",
    -- init = function()
    --     require("core.utils").lazy_load "nvim-lspconfig"
    -- end,
    config = function()
        require("shortcuts").set_shortcuts("lspconfig")
        require("lspconfig").lua_ls.setup({})
    end,
}
