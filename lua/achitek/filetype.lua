local M = {}

function M.setup()
  vim.filetype.add({
    filename = {
      Achitekfile = "achitekfile",
    },
  })
end

return M

