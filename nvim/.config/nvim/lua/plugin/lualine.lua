local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

-- require("lualine").setup({
--   view = {
--     side = 'right'
--   }
-- })

require("lualine").setup()

