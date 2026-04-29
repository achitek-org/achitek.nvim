# achitek.nvim

Neovim integration for Achitek projects.

## Features

- Filetype detection for `Achitekfile` and `achitekfile`.
- `achitek-ls` language server registration and startup.
- Native `vim.lsp` support on newer Neovim versions.
- `nvim-lspconfig` fallback for older Neovim versions.
- `nvim-treesitter` parser registration for the `achitekfile` language.
- `:checkhealth achitek` diagnostics for filetype, language server, parser, and query setup.

## Configuration

Call `setup()` from your Neovim config:

```lua
require("achitek").setup()
```

Default configuration:

```lua
require("achitek").setup({
  filetype = { -- Registers Achitek filenames with Neovim's filetype system.
    enabled = true, -- Set to false if you define the filetype elsewhere.
  },
  lsp = { -- Configures the Achitek language server.
    enabled = true, -- Set to false to skip LSP setup.
    name = "achitek", -- Name used for the Neovim LSP client config.
    cmd = { "achitek-ls" }, -- Command used to start the language server.
    filetypes = { "achitekfile" }, -- Filetypes that should attach to achitek-ls.
    root_markers = { { "Achitekfile" }, ".git" }, -- Project root markers for LSP workspaces.
    single_file_support = true, -- Allow the server to attach outside a detected project root.
  },
  treesitter = { -- Registers the Achitek parser with nvim-treesitter.
    enabled = true, -- Set to false if your Neovim distribution provides the parser.
    parser_name = "achitekfile", -- Parser name used by nvim-treesitter.
    install_info = { -- Parser installation metadata.
      url = "https://github.com/achitek-org/tree-sitter-achitek", -- Grammar repository.
      files = { "src/parser.c" }, -- Generated parser sources.
      branch = "main", -- Grammar repository branch.
      generate_requires_npm = false, -- Parser does not need npm during generation.
      requires_generate_from_grammar = false, -- Parser sources are committed.
    },
    filetype = "achitekfile", -- Filetype associated with the parser.
  },
})
```

Disable individual integrations:

```lua
require("achitek").setup({
  filetype = {
    enabled = false,
  },
  lsp = {
    enabled = false,
  },
  treesitter = {
    enabled = false,
  },
})
```

Use a local `achitek-ls` build:

```lua
require("achitek").setup({
  lsp = {
    cmd = {
      vim.fn.expand("~/development/achitek-org/achitek-ls/target/debug/server"),
    },
  },
})
```

Customize project root detection:

```lua
require("achitek").setup({
  lsp = {
    root_markers = { { "Achitekfile" }, "achitek.toml", ".git" },
  },
})
```
