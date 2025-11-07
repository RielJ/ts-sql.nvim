# ts-sql.nvim

A Neovim plugin that provides SQL syntax highlighting and formatting for template strings in TypeScript, JavaScript, TSX, and JSX files.

## Features

- **SQL Syntax Highlighting**: Automatically highlights SQL syntax within template strings
- **SQL Formatting**: Format SQL template strings using `sql-formatter`
- **Template Interpolation Support**: Preserves TypeScript/JavaScript expressions during formatting
- **Multi-language Support**: Works with TypeScript, JavaScript, TSX, and JSX
- **Configurable**: Customize function names, formatter options, keybindings, and more
- **Auto-format on Save**: Optional automatic formatting when saving files

## Requirements

- Neovim >= 0.9.0
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with TypeScript/JavaScript parsers installed
- `sql-formatter` (installed via Mason or available via `pnpx`)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "yourusername/ts-sql.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  config = function()
    require("ts-sql").setup({
      -- your configuration here (optional)
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "yourusername/ts-sql.nvim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  config = function()
    require("ts-sql").setup()
  end,
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'yourusername/ts-sql.nvim'
```

Then in your `init.lua`:

```lua
require("ts-sql").setup()
```

## Usage

### Syntax Highlighting

SQL syntax highlighting is automatically applied to template strings when using specific function names (default: `sql`, `tx`, `sqlClient`):

```typescript
import { sql } from "./db";

const users = await sql`
  SELECT id, name, email
  FROM users
  WHERE active = true
`;
```

### Formatting SQL Templates

Format SQL template strings using the `:FormatSQLTemplates` command:

```typescript
// Before formatting
const query = sql`SELECT id,name,email FROM users WHERE active=true`;

// After :FormatSQLTemplates
const query = sql`
  SELECT
    id,
    name,
    email
  FROM
    users
  WHERE
    active = true
`;
```

The formatter intelligently preserves TypeScript/JavaScript interpolations:

```typescript
const query = sql`
  SELECT
    id,
    name
  FROM
    users
  WHERE
    id = ${userId}
    AND created_at > ${startDate}
`;
```

## Configuration

### Default Configuration

```lua
require("ts-sql").setup({
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

  -- Keybindings (set to false to disable, or provide a keymap string)
  keymaps = {
    format = false, -- e.g., "<leader>fq"
  },

  -- Auto-format on save
  format_on_save = false,
})
```

### Example Configurations

#### With Keybinding

```lua
require("ts-sql").setup({
  keymaps = {
    format = "<leader>fq",
  },
})
```

#### Auto-format on Save

```lua
require("ts-sql").setup({
  format_on_save = true,
})
```

#### Custom Function Names

```lua
require("ts-sql").setup({
  function_names = { "sql", "prisma", "query", "db" },
})
```

#### Custom Formatter

```lua
require("ts-sql").setup({
  formatter = {
    command = { "sql-formatter", "--language", "mysql" },
    language = "mysql",
  },
})
```

#### Complete Configuration Example

```lua
require("ts-sql").setup({
  function_names = { "sql", "tx", "sqlClient", "query" },
  formatter = {
    command = nil, -- auto-detect
    language = "postgresql",
  },
  keymaps = {
    format = "<leader>fq",
  },
  format_on_save = false,
})
```

## Manual Keybinding Setup

If you prefer to set up keybindings manually:

```lua
require("ts-sql").setup({
  keymaps = {
    format = false, -- disable default keybinding
  },
})

-- Set up your own keybinding
vim.keymap.set("n", "<leader>sq", "<cmd>FormatSQLTemplates<CR>", {
  desc = "Format SQL templates",
})
```

## Commands

- `:FormatSQLTemplates` - Format all SQL template strings in the current buffer

## Installing sql-formatter

### Via Mason (Recommended)

```vim
:MasonInstall sql-formatter
```

### Via npm

```bash
npm install -g sql-formatter
```

### Via pnpm

```bash
pnpm add -g sql-formatter
```

The plugin will automatically use the formatter in this order of preference:
1. Mason-installed `sql-formatter`
2. `pnpx sql-formatter` (downloads and runs on-demand)
3. Custom command if configured

## Supported Languages

- TypeScript (`.ts`)
- JavaScript (`.js`)
- TypeScript React (`.tsx`)
- JavaScript React (`.jsx`)

## How It Works

1. **Syntax Highlighting**: Uses treesitter injection queries to identify SQL template strings and apply SQL syntax highlighting
2. **Formatting**:
   - Extracts SQL from template strings
   - Replaces template interpolations with placeholders
   - Formats SQL using `sql-formatter`
   - Restores template interpolations
   - Re-indents and updates the buffer

## Troubleshooting

### Syntax highlighting not working

Make sure you have the TypeScript/JavaScript treesitter parsers installed:

```vim
:TSInstall typescript tsx javascript
```

### Formatter not found

Install `sql-formatter` via Mason or npm/pnpm, or the plugin will use `pnpx` which downloads it on-demand.

### SQL not detected

Check that your function names match the configured `function_names`. The default values are `sql`, `tx`, and `sqlClient`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Credits

Created by [Your Name]
