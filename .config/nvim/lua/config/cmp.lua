local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  --view = { entries = 'native' },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm(),
    ['('] = function(fallback)
      if cmp.visible() and cmp.get_selected_entry() ~= nil then
        cmp.confirm()
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

local cmp_cmdline_overrides = {
  -- C-n and C-p close the completion window and fall back to the defaults,
  -- which is history up/down for me.
  ['<C-n>'] = cmp.mapping({
    c = function(fallback)
      if cmp.visible() then
        cmp.close()
      end
      fallback()
    end,
  }),
  ['<C-p>'] = cmp.mapping({
    c = function(fallback)
      if cmp.visible() then
        cmp.close()
      end
      fallback()
    end,
  }),
  ['<C-j>'] = cmp.mapping({
    c = function(fallback)
      if cmp.visible() then
        return cmp.select_next_item()
      end
      fallback()
    end,
  }),
  ['<C-k>'] = cmp.mapping({
    c = function(fallback)
      if cmp.visible() then
        return cmp.select_prev_item()
      end
      fallback()
    end,
  }),
  -- This is still not working exactly as intended. I would explete the
  -- completwion menu to stay up after the first completion, but it closes, and
  -- another hit of `C-l` needs to happen.
  ['<C-l>'] = cmp.mapping({
    c = function(fallback)
      cmp.confirm({select = true})
      cmp.complete()
    end,
  }),
  ['<C-y>'] = {
    c = cmp.mapping.confirm({ select = true }),
  },
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(cmp_cmdline_overrides),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(cmp_cmdline_overrides),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
