local M = {}

M.defaults = {
  -- Function names that indicate SQL template strings
  function_names = { "sql", "tx", "sqlClient" },

  -- SQL formatter configuration
  formatter = {
    -- Command to use for formatting. Can be a string or a table
    -- If nil, will auto-detect (mason bin -> pnpx sql-formatter)
    command = nil,
    -- SQL language/dialect for the formatter
    language = "postgresql",
  },

  -- Keybindings (set to false to disable)
  keymaps = {
    format = false, -- e.g., "<leader>fq"
  },

  -- Auto-format on save
  format_on_save = false,
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
