local M = {}

local defaults = {
  filetype = {
    enabled = true,
  },
  lsp = {
    enabled = true,
  },
  treesitter = {
    enabled = true,
  },
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})

  if config.filetype.enabled then
    require("achitek.filetype").setup(config.filetype)
  end

  if config.treesitter.enabled then
    require("achitek.treesitter").setup(config.treesitter)
  end

  if config.lsp.enabled then
    require("achitek.lsp").setup(config.lsp)
  end
end

return M

