-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach_common = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
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

  if client.server_capabilities.documentHighlightProvider then
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

  -- TODOrequire("nvim-navic").attach(client, bufnr)
end

local on_attach_clangd = function(client, bufnr)
  on_attach_common(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  --vim.keymap.set({'v'}, '<Leader>f', function()
  --  vim.lsp.buf.format { async = false }
  --  vim.api.nvim_input "<Esc>"
  --end, bufopts)
end

local local_config = function()
  local lspconfig = require("lspconfig")

  lspconfig.clangd.setup {
    on_attach = on_attach_clangd,
    filetypes = { 'cpp' },
    cmd = { "clangd", "--background-index", "-j", "4"}
    --capabilities = capabilities,
  }

  local function setup_icons()
    local sign_icons = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " "
    }
    get_diag_icon = function(diagnostic)
      local diag_icons = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN]  = " ",
        [vim.diagnostic.severity.INFO]  = " ",
        [vim.diagnostic.severity.HINT]  = " "
      }
      return diag_icons[diagnostic.severity]
    end
    for type, icon in pairs(sign_icons) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config({
      virtual_text = {
        prefix = get_diag_icon,
      },
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
    })
  end
  setup_icons()
end


return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    --"nvimtools/none-ls.nvim",
    --"williamboman/mason-lspconfig.nvim",
  },
  config = local_config
}

