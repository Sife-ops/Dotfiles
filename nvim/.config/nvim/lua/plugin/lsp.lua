return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        { "L3MON4D3/LuaSnip" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/nvim-cmp" },
        { "neovim/nvim-lspconfig" },
        {
            "windwp/nvim-autopairs",
            opts = {
                -- fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim" },
            },
            config = function(_, opts)
                require("nvim-autopairs").setup(opts)
                -- setup cmp for autopairs
                local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end,
        },
    },
    config = function()
        local lz = require("lsp-zero")

        lz.on_attach(function(_, bufnr)
            -- see :help lsp-zero-keybindings
            lz.default_keymaps({ buffer = bufnr })
            require("shortcuts").set_shortcuts("lsp")
        end)

        require("lspconfig").lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        })

        require("lspconfig").gopls.setup({})
    end,
}
