local local_config = function()
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
      { name = "path" },
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

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this
  -- won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(cmp_cmdline_overrides),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Enable completion for searches.
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(cmp_cmdline_overrides),
    sources = {
      { name = 'buffer' }
    }
  })


  -- This allows automatic insertion of parentheses after selecting a function
  -- or method.
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    -- `cmp-nvim-lsp` requires a snippet engine.
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "hrsh7th/vim-vsnip",
    -- Dependencies for extra functionalities.
    "windwp/nvim-autopairs",
  },
  config = local_config
}
