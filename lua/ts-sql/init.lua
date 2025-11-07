local M = {}

local config = require("ts-sql.config")
local formatter = require("ts-sql.formatter")

-- Setup function to initialize the plugin
function M.setup(opts)
  config.setup(opts)
end

-- Format SQL in current buffer
function M.format_sql()
  formatter.format_sql_in_buffer(nil, config.options)
end

-- Get current configuration
function M.get_config()
  return config.options
end

return M
