# achitek.nvim

Neovim integration for Achitek projects.

This plugin provides:

- `Achitekfile` filetype detection
- `achitek-ls` language server setup
- `nvim-treesitter` parser registration for `achitekfile`

Tree-sitter queries live in
[`achitek-org/tree-sitter-achitek`](https://github.com/achitek-org/tree-sitter-achitek),
which is the source of truth for Achitekfile syntax highlighting.

## Installation

Install the language server first:

```sh
cargo install achitek-ls
```

Then install this plugin with your plugin manager.

### lazy.nvim

Install the parser with `nvim-treesitter`:

```vim
:TSInstall achitekfile
```

Make the grammar queries available on Neovim's `runtimepath`. With `lazy.nvim`,
you can install the grammar repo as a runtime dependency:

```lua
{
  "achitek-org/achitek.nvim",
  dependencies = {
    "achitek-org/tree-sitter-achitek",
  },
  ft = "achitekfile",
  opts = {},
}
```

Check your setup:

```vim
:checkhealth achitek
```

### Nix-managed Neovim

If your Neovim distribution already provides the `achitekfile` tree-sitter parser,
you can disable parser registration and keep only filetype/LSP setup:

```lua
require("achitek").setup({
  treesitter = {
    enabled = false,
  },
})
```

## Configuration

Defaults:

```lua
require("achitek").setup({
  filetype = {
    enabled = true,
  },
  lsp = {
    enabled = true,
    cmd = { "achitek-ls" },
    root_markers = { { "Achitekfile" }, ".git" },
  },
  treesitter = {
    enabled = true,
  },
})
```

Use a local development server build:

```lua
require("achitek").setup({
  lsp = {
    cmd = {
      vim.fn.expand("~/development/achitek-org/achitek-ls/target/debug/server"),
    },
  },
})
```

If `achitek-ls` is not installed, the plugin registers the server config but does
not enable it automatically. Install the server and reopen an `Achitekfile`.
