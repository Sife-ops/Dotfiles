local shortcuts = {
    native = {
        i = {
            ["jk"] = { "<esc>" },
        },

        n = {
            -- ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
            ["<leader>w"] = { "<cmd> wa <CR>" },
            ["<leader>z"] = { "<cmd> qa! <CR>" },
        },
    },

    telescope = {
        n = {
            ["<leader>ff"] = { "<cmd> Telescope find_files <CR>" },
            ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>" },
            ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>" },
            ["<leader>fb"] = { "<cmd> Telescope buffers <CR>" },
            ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>" },
            -- ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
            ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>" },

            ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>" },
            ["<leader>gt"] = { "<cmd> Telescope git_status <CR>" },

            -- ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
            -- ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

            ["<leader>ma"] = { "<cmd> Telescope marks <CR>" },
        },
    },

    nvimtree = {
        n = {
            ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>" },
        },
    },

    lspconfig = {
        n = {
            ["<leader>fm"] = {
                function()
                    vim.lsp.buf.format { async = true }
                end
            },
            ["gd"] = {
                function()
                    vim.lsp.buf.definition()
                end
            },
            ["K"] = {
                function()
                    vim.lsp.buf.hover()
                end
            },
            ["gD"] = {
                function()
                    vim.lsp.buf.declaration()
                end,
                -- "LSP declaration",
            },
        }
    },
}

local M = {}

M.set_shortcuts = function(plugin_name)
    local plugin_shortcuts = shortcuts[plugin_name]
    for mode, mode_shortcuts in pairs(plugin_shortcuts) do
        for mode_shortcut, values in pairs(mode_shortcuts) do
            local opts = values.opts or {}
            -- todo: desc
            vim.keymap.set(mode, mode_shortcut, values[1], opts)
        end
    end
end

return M
