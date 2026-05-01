local M = {}

local function health_api()
  local health = vim.health or {}

  return {
    start = health.start or health.report_start,
    ok = health.ok or health.report_ok,
    warn = health.warn or health.report_warn,
    error = health.error or health.report_error,
    info = health.info or health.report_info,
  }
end

local function has_parser(lang)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end

  if type(parsers.has_parser) == "function" then
    return parsers.has_parser(lang)
  end

  local parser_configs = parsers.get_parser_configs()
  return parser_configs[lang] ~= nil
end

function M.check()
  local health = health_api()

  health.start("achitek.nvim")

  if vim.filetype.match({ filename = "Achitekfile" }) == "achitekfile" then
    health.ok("Achitekfile resolves to the achitekfile filetype")
  else
    health.error("Achitekfile does not resolve to the achitekfile filetype")
  end

  if vim.filetype.match({ filename = "README.md.tera" }) == "tera" then
    health.ok(".tera files resolve to the tera filetype")
  else
    health.error(".tera files do not resolve to the tera filetype")
  end

  if vim.fn.executable("achitek-ls") == 1 then
    health.ok("achitek-ls is executable")
  else
    health.warn("achitek-ls was not found on PATH", {
      "Install it with `cargo install achitek-ls` once published.",
      "For local development, configure `require('achitek').setup({ lsp = { cmd = { '/path/to/server' } } })`.",
    })
  end

  local ok = pcall(require, "nvim-treesitter.parsers")
  if ok then
    health.ok("nvim-treesitter is available")
  else
    health.warn("nvim-treesitter is not available", {
      "Install nvim-treesitter to use Achitekfile syntax highlighting.",
    })
  end

  if has_parser("achitekfile") then
    health.ok("achitekfile tree-sitter parser is registered")
  else
    health.warn("achitekfile tree-sitter parser is not registered", {
      "Call `require('achitek').setup()` before running this check.",
      "Then install the parser with `:TSInstall achitekfile`.",
      "The grammar and queries are maintained in achitek-org/tree-sitter-achitek.",
    })
  end

  local highlight_queries = vim.api.nvim_get_runtime_file("queries/achitekfile/highlights.scm", true)
  if #highlight_queries > 0 then
    health.ok("achitekfile highlight queries are available")
  else
    health.warn("achitekfile highlight queries were not found on runtimepath", {
      "Add achitek-org/tree-sitter-achitek to runtimepath, or use a distro package that includes its queries.",
      "The queries should stay maintained in achitek-org/tree-sitter-achitek.",
    })
  end
end

return M
