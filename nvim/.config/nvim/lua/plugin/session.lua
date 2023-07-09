return {
    "rmagatti/auto-session",
    opts = {
        log_level = "error",
        -- todo: regarded settings that don't do anything
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        session_lens = {
            load_on_setup = true,
        }
    },
    config = function(_, opts)
        require("auto-session").setup(opts)
    end
}
