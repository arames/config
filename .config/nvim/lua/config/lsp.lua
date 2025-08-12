vim.lsp.config.clangd = {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}

vim.lsp.enable({"clangd"})

-- Enable auto-triggering completion on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

---- Extra trigger characters for C++
--vim.api.nvim_create_autocmd("LspAttach", {
--  callback = function(ev)
--    local client = vim.lsp.get_client_by_id(ev.data.client_id)
--    if client and client.name == "clangd" then
--      client.server_capabilities.completionProvider.triggerCharacters = {
--        ".", "->", "::"
--      }
--    end
--  end,
--})


--
--vim.api.nvim_create_autocmd("FileType", {
--  -- This handler will fire when the buffer's 'filetype' is "python"
--  pattern = "cpp",
--  callback = function(ev)
--    vim.lsp.start({
--      name = "clangd",
--      cmd = {"clangd", "--background-index"},
--    })
--  end,
--})

local function setup_signs()
  local signs = {
    Error = "\u{2717}",
    Warn = "\u{26A0}",
    Hint = "!",
    Info = "\u{1F6C8}"
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  })
end
setup_signs()
