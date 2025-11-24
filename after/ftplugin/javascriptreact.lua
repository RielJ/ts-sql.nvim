local ok, ts_sql = pcall(require, "ts-sql")
if not ok then
  return
end

-- Create buffer-local command for formatting entire buffer
vim.api.nvim_buf_create_user_command(0, "FormatSQLTemplates", function()
  ts_sql.format_sql()
end, {
  desc = "Format SQL template strings in current buffer",
})

-- Create buffer-local command for formatting visual selection
vim.api.nvim_buf_create_user_command(0, "FormatSQLSelection", function()
  ts_sql.format_sql_selection()
end, {
  range = true,
  desc = "Format SQL template strings in visual selection",
})

-- Set up keymap if configured
local config = ts_sql.get_config()
if config.keymaps.format then
  -- Normal mode: format entire buffer
  vim.keymap.set("n", config.keymaps.format, "<cmd>FormatSQLTemplates<CR>", {
    buffer = 0,
    noremap = true,
    silent = true,
    desc = "Format SQL templates",
  })
  
  -- Visual mode: format selection
  vim.keymap.set("v", config.keymaps.format, ":<C-u>FormatSQLSelection<CR>", {
    buffer = 0,
    noremap = true,
    silent = true,
    desc = "Format SQL templates in selection",
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
