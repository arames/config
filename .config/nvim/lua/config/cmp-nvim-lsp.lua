local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<C-p>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm(),
    ['('] = cmp.mapping.confirm(),
    ['<Space>'] = cmp.mapping.confirm(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }
  }, {
    { name = 'buffer' },
  })
})
