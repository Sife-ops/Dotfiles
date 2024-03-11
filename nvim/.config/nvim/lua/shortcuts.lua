local shortcuts = {
    native = {
        i = {
            ["jk"] = { "<esc>" },
        },

        n = {
            -- save/quit
            ["<leader>s"] = { "<cmd> wa <CR>" },
            ["<leader>z"] = { "<cmd> wqa <CR>" },
            ["<leader>q"] = { "<cmd> qa! <CR>" },

            -- tab/window
            ["<leader>ww"] = { "<cmd> wincmd w <CR>" },
            ["<leader>wc"] = { "<cmd> close <CR>" },
            ["<leader>ws"] = { "<cmd> split <CR>" },
            ["<leader>wv"] = { "<cmd> vsplit <CR>" },
            ["<leader>n"] = { "<cmd> tabn <CR>" },
            ["<leader>p"] = { "<cmd> tabp <CR>" },
        },
    },

    telescope = {
        n = {
            ["<leader>ft"] = { "<cmd> Telescope colorscheme <CR>" },
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
            ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>" },
        },
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
            vim.keymap.set(mode, mode_shortcut, values[1], vim.tbl_deep_extend("force", o1, o2))
        end
    end
end

return M
