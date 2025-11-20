vim.lsp.config.clangd = {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}

vim.lsp.enable({"clangd", "basedpyright"})

-- Define or modify the 'basedpyright' LSP configuration
vim.lsp.config('basedpyright', {
  -- This table contains the settings passed to the language server
  settings = {
    basedpyright = {
      analysis = {
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'basic', -- Adjust as needed: 'off', 'basic', 'standard', etc.
        diagnosticMode = 'workspace',
        autoSearchPath = true,
        inlayHints = {
          callArgumentNames = true,
        },
      },
      -- Optional: specify the path to your Python interpreter or venv
      -- python = {
      --   venvPath = '/path/to/venv',
      -- },
    },
  },
})

-- Enable the 'basedpyright' language server configuration
-- This should be called after defining the config
vim.lsp.enable('basedpyright')


-- Enable auto-triggering completion on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    --vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<space>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)
    --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>cs', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

    if client and client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
      vim.api.nvim_create_autocmd("CursorMoved", {
          callback = function()
            vim.lsp.buf.clear_references()
            vim.lsp.buf.document_highlight()
          end,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Highlight document",
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
