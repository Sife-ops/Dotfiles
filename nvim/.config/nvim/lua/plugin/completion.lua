-- sources
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/completion.lua

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            dependencies = "rafamadriz/friendly-snippets",
            -- opts = {
            --     history = true,
            --     updateevents = "TextChanged,TextChangedI"
            -- },
            config = function(_, _)
                require("luasnip.loaders.from_vscode").lazy_load()
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

        {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
        },
    },
    opts = function()
        local cmp = require("cmp")

        return {
            completion = {
                completeopt = "menu, menuone", -- noselect?
            },

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },

            sources = {
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },

            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    -- select = true,
                }),
            },

            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "text",
                    menu = {
                        nvim_lua = "[api]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[snip]",
                        buffer = "[buf]",
                        path = "[path]",
                    }
                })
            }
        }
    end,
    config = function(_, opts)
        require("cmp").setup(opts)
    end,
}
