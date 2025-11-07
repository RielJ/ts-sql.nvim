local ok, ts_sql = pcall(require, "ts-sql")
if not ok then
  return
end

-- Create buffer-local command
vim.api.nvim_buf_create_user_command(0, "FormatSQLTemplates", function()
  ts_sql.format_sql()
end, {
  desc = "Format SQL template strings in current buffer",
})

-- Set up keymap if configured
local config = ts_sql.get_config()
if config.keymaps.format then
  vim.keymap.set("n", config.keymaps.format, "<cmd>FormatSQLTemplates<CR>", {
    buffer = 0,
    noremap = true,
    silent = true,
    desc = "Format SQL templates",
  })
end

-- Set up auto-format on save if configured
if config.format_on_save then
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      ts_sql.format_sql()
    end,
    desc = "Auto-format SQL template strings on save",
  })
end
