local M = {}

function M.setup()
  vim.filetype.add({
    filename = {
      Achitekfile = "achitekfile",
      achitekfile = "achitekfile",
    },
    extension = {
      tera = "tera",
    },
  })
end

return M
