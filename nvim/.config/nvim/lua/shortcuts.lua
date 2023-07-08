local shortcuts = {
    native = {
        n = {
            -- ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
            ["<leader>w"] = { "<cmd> wa <CR>" },
            ["<leader>q"] = { "<cmd> qa! <CR>" },
        },
    },

    telescope = {
        n = {
            ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", opts = { desc = "Find files" } },
            ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
            ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
            ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", opts = { desc = "Find buffers" } },
            ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
            -- ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
            ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

            ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
            ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },

            -- ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
            -- ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

            ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
        },
    },

    nvimtree = {
        n = {
            ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
        },
    }
}

local M = {}

M.set_shortcuts = function(plugin_name)
    local plugin_shortcuts = shortcuts[plugin_name]
    for mode, mode_shortcuts in pairs(plugin_shortcuts) do
        for mode_shortcut, values in pairs(mode_shortcuts) do
            vim.keymap.set(mode, mode_shortcut, values[1], values.opts or {})
        end
    end
end

return M
