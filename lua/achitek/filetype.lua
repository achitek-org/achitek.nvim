local M = {}

function M.setup()
  vim.filetype.add({
    filename = {
      Achitekfile = "achitekfile",
      achitekfile = "achitekfile",
    },
  })
end

return M
