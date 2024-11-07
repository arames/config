
vim.api.nvim_create_autocmd("FileType", {
  -- This handler will fire when the buffer's 'filetype' is "python"
  pattern = "cpp",
  callback = function(ev)
    vim.lsp.start({
      name = "clangd",
      cmd = {"clangd", "--background-index"},
    })
  end,
})

local function setup_signs()
  local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " "
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  })
end
setup_signs()
