return {
  "nvim-treesitter/nvim-treesitter",
  --dependencies = {
  --  "nvim-treesitter/nvim-treesitter-textobjects",
  --},
  branch = "main",
  version = false,
  build = ":TSUpdate",
  lazy = false,
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "diff",
      "gitcommit",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "rust",
      "tablegen",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_settings", { clear = true }),
      callback = function(ev)
        local lang = ev.match, vim.treesitter.language.get_lang(ev.match)

        if not lang then
          return
        end

        local has_parser = pcall(vim.treesitter.get_parser, ev.buf, lang)
        if not has_parser then
          return
        end

        local function enabled(feat, query)
          local f = opts[feat] or {}
          local is_enabled = f.enable ~= false
            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
          if not is_enabled then
            return false
          end
          if query then
            return vim.treesitter.query.get(lang, query) ~= nil
          end
          return false
        end

        if enabled("highlight", "highlights") then
          pcall(vim.treesitter.start, ev.buf, lang)
        end

        if enabled("indent", "indents") then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if enabled("folds", "folds") then
          vim.wo[0].foldmethod = "expr"
          vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
