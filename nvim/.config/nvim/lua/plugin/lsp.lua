return {
    "neovim/nvim-lspconfig",
    init = function()
        require("shortcuts").set_shortcuts("lsp_global")
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                require("shortcuts").set_shortcuts("lsp_onattach", { buffer = event.buf })
            end,
        })
    end,
    config = function()
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
