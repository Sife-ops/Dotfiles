return {
    "aserowy/tmux.nvim",
    opts = {
        copy_sync = {
            enable = false
        }
    },
    config = function(_, opts)
        require("tmux").setup(opts)
    end
}
