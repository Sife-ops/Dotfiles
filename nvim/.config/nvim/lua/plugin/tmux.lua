return {
    "aserowy/tmux.nvim",
    config = function(_, opts)
        require("tmux").setup(opts)
    end
}
