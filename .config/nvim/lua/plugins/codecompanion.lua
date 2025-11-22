return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
          opts = {
            system_prompt = function(ctx)
              return ctx.default_system_prompt .. "Additional context: Use PyTorch by default for ML tasks."
            end
          },
        },
        inline = {
          adapter = "gemini",
          opts = {
            system_prompt = function(ctx)
              return ctx.default_system_prompt .. "Additional context: Use PyTorch by default for ML tasks."
            end
          },
        },
      },
      display = {
        chat = {
          window = {
            position = "right",
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    })

    vim.keymap.set("n", "<Leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "Toggle CodeCompanion Chat" })

    -- Enable automatic omni completion for slash commands.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codecompanion",
      callback = function(ev)
        local function setup_omni_completion_for_char(char)
          vim.keymap.set("i", char, function()
            vim.api.nvim_feedkeys(char, "n", false)
            vim.schedule(function()
              if vim.fn.pumvisible() == 0 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
              end
            end)
          end, { buffer = ev.buf })
        end

        setup_omni_completion_for_char("/")
        setup_omni_completion_for_char("@")
        setup_omni_completion_for_char("#")
      end,
    })
  end
}

