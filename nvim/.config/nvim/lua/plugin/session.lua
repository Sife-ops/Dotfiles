return {
    "rmagatti/auto-session",
    opts = {
        log_level = "error",
        session_lens = {
            load_on_setup = true,
        }
    },
    config = function(_, opts)
        require("auto-session").setup(opts)
    end
}
