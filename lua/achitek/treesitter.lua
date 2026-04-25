local M = {}

local defaults = {
  parser_name = "achitekfile",
  install_info = {
    url = "https://github.com/achitek-org/tree-sitter-achitek",
    files = { "src/parser.c" },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "achitekfile",
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})

  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return
  end

  local parser_config = parsers.get_parser_configs()
  parser_config[config.parser_name] = vim.tbl_deep_extend("force", parser_config[config.parser_name] or {}, {
    install_info = config.install_info,
    filetype = config.filetype,
  })
end

return M

