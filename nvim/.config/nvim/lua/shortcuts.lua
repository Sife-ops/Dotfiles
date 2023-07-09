local shortcuts = {
    native = {
        i = {
            ["jk"] = { "<esc>" },
        },

        n = {
            ["<leader>w"] = { "<cmd> wa <CR>" },
            ["<leader>z"] = { "<cmd> wqa <CR>" },
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
            ["<leader>fs"] = { function() require("auto-session.session-lens").search_session() end },

            ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>" },
            ["<leader>gt"] = { "<cmd> Telescope git_status <CR>" },

            -- ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
            -- ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

            ["<leader>ma"] = { "<cmd> Telescope marks <CR>" },
        },
    },

    nvimtree = {
        n = {
            ["<leader>t"] = { "<cmd> NvimTreeFocus <CR>" },
        },
    },

    lsp_global = {
        n = {
            ["[d"] = { vim.diagnostic.goto_prev, "next diagnostic" },
            ["]d"] = { vim.diagnostic.goto_next, "previous diagnostic" },
            ["<leader>ll"] = { vim.diagnostic.setloclist, "list diagnostic" },
            ["<leader>ld"] = { vim.diagnostic.open_float, "open diagnostic" },
        }
    },

    lsp_onattach = {
        n = {
            ["K"] = { vim.lsp.buf.hover },
            ["gD"] = { vim.lsp.buf.declaration, "lsp declaration" },
            ["gd"] = { vim.lsp.buf.definition, "lsp definition" },
            ["gi"] = { vim.lsp.buf.implementation, "lsp implementation" },
            ["gr"] = { vim.lsp.buf.references, "lsp references" },
            ["<leader>lf"] = { function() vim.lsp.buf.format({ async = true }) end, "format" },
            ["<leader>ls"] = { vim.lsp.buf.signature_help, "signature help" },
            ["<leader>lwa"] = { vim.lsp.buf.add_workspace_folder, "add workspace folder" },
            ["<leader>lwr"] = { vim.lsp.buf.remove_workspace_folder, "remove workspace folder" },
            ["<leader>lwl"] = {
                function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                "list workspace folders",
            },
            ["<leader>lD"] = { vim.lsp.buf.type_definition, "type definition" },
            ["<leader>lra"] = { vim.lsp.buf.rename, "rename" },
            ["<leader>lca"] = { vim.lsp.buf.code_action, "code action" },
        },
        v = {
            ["<leader>lca"] = { vim.lsp.buf.code_action, "code action" },
        }
    },
}

local M = {}

M.set_shortcuts = function(plugin_name, opts)
    local o1 = opts or {}
    local plugin_shortcuts = shortcuts[plugin_name]
    for mode, mode_shortcuts in pairs(plugin_shortcuts) do
        for mode_shortcut, values in pairs(mode_shortcuts) do
            local o2 = values.opts or {}
            if type(values[2]) == "string" then
                o2.desc = values[2]
            end
            local o = vim.tbl_deep_extend("force", o1, o2)
            vim.keymap.set(mode, mode_shortcut, values[1], o)
        end
    end
end

return M
