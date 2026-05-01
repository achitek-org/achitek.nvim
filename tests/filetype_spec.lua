require("achitek.filetype").setup()

local cases = {
  Achitekfile = "achitekfile",
  achitekfile = "achitekfile",
  ["README.md.tera"] = "tera",
  ["main.py.tera"] = "tera",
}

for filename, expected in pairs(cases) do
  local actual = vim.filetype.match({ filename = filename })
  assert(
    actual == expected,
    string.format("expected %s to resolve to %s, got %s", filename, expected, vim.inspect(actual))
  )
end
