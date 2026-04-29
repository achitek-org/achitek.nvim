local tests = {
  "tests/filetype_spec.lua",
}

for _, test in ipairs(tests) do
  dofile(test)
end
