return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        { "neovim/nvim-lspconfig" },

        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "hrsh7th/cmp-nvim-lua" },
                { "hrsh7th/cmp-path" },

                { 'saadparwaiz1/cmp_luasnip' },
                {
                    "L3MON4D3/LuaSnip",
                    dependencies = { "rafamadriz/friendly-snippets" },
                },
            },
            opts = {
                sources = {
                    {
                        name = "buffer",
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                    },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "path" },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            },
            config = function(_, opts)
                require("cmp").setup(opts)
            end,
        },

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
        -- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/go.json
        require("luasnip.loaders.from_vscode").lazy_load()

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
        require("lspconfig").erlangls.setup({})
    end,
}
