local M = {}

local config = require("ts-sql.config")
local formatter = require("ts-sql.formatter")

-- Register injection queries with TreeSitter
local function register_injections()
  -- Get the plugin directory
  local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
  
  -- Languages to register (map from directory name to TreeSitter language name)
  local languages = {
    { dir = 'typescript', lang = 'typescript' },
    { dir = 'typescriptreact', lang = 'tsx' },
    { dir = 'javascript', lang = 'javascript' },
    { dir = 'javascriptreact', lang = 'jsx' },
  }
  
  for _, lang_info in ipairs(languages) do
    local query_file = plugin_dir .. '/queries/' .. lang_info.dir .. '/injections.scm'
    
    if vim.fn.filereadable(query_file) == 1 then
      -- Read the query file
      local query_content = table.concat(vim.fn.readfile(query_file), '\n')
      
      -- Try to parse and set the query
      local ok, err = pcall(function()
        vim.treesitter.query.set(lang_info.lang, 'injections', query_content)
      end)
      
      if not ok then
        vim.notify(
          string.format('ts-sql.nvim: Failed to register injection query for %s (%s): %s', 
            lang_info.dir, lang_info.lang, err),
          vim.log.levels.WARN
        )
      end
    end
  end
end

-- Setup function to initialize the plugin
function M.setup(opts)
  config.setup(opts)
  
  -- Register injection queries
  register_injections()
end

-- Format SQL in current buffer
function M.format_sql()
  formatter.format_sql_in_buffer(nil, config.options)
end

-- Format SQL in visual selection
function M.format_sql_selection()
  formatter.format_sql_in_selection(nil, config.options)
end

-- Get current configuration
function M.get_config()
  return config.options
end

-- Toggle SQL highlighting
function M.toggle_highlighting()
  vim.notify('ts-sql.nvim: Highlighting is automatic via TreeSitter injections', vim.log.levels.INFO)
  vim.notify('Make sure you have run require("ts-sql").setup()', vim.log.levels.INFO)
end

-- Test SQL highlighting (visual inspection)
function M.test_highlights()
  local test_file = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h") .. '/tests/test-highlights-visual.lua'
  
  if vim.fn.filereadable(test_file) == 1 then
    vim.cmd('luafile ' .. test_file)
  else
    vim.notify('Test file not found: ' .. test_file, vim.log.levels.ERROR)
  end
end

return M
