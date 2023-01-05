-- Disable a few built-in plugins ================================{{{2
local disabled_built_ins = {
  "gzip",
  "man",
  "matchit",
  "matchparen",
  "shada_plugin",
  "tar",
  "tarPlugin",
  "zip",
  "zipPlugin",
}

for i = 1, #disabled_built_ins do
  vim.g["loaded_" .. disabled_built_ins[i]] = 1
end

-- Bootstrap packer.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- Used frequently ==================================={{{2

  -- Quickly find files.
  use {
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
    requires = {{"nvim-lua/plenary.nvim"}},
    config = function() require("config.telescope") end
  }

  -- Improved status bar.
  use {
    "nvim-lualine/lualine.nvim",
    requires = {{"kyazdani42/nvim-web-devicons"}, {"SmiteshP/nvim-navic"}},
    config = function() require("config.lualine") end
  }

  -- Very easily jump around.
  use {
    "ggandor/leap.nvim",
    config = function() require("config.leap") end
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      {"nvim-treesitter/nvim-treesitter-textobjects"},
      {"nvim-treesitter/playground"} -- Used to inspect or debug treesitter.
    },
    config = function() require("config.treesitter") end
  }

  -- Display color codes.
  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require("colorizer").setup({'*'; }, {mode = "foreground" }) end
  }

  -- LSP ==========================={{{3

  use {
    "neovim/nvim-lspconfig",
    config = function() require("config.nvim-lspconfig") end,
    requires = {
      -- Automatic completion.
      {"hrsh7th/nvim-cmp"},
      -- Context information in lualine.
      {"SmiteshP/nvim-navic"}
    },
    after = {"nvim-navic", "nvim-cmp"},
    config = function() require("config.lspconfig") end
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"hrsh7th/cmp-cmdline"},
      -- `cmp-nvim-lsp` requires a snippet engine.
      {"hrsh7th/cmp-vsnip"},
      {"hrsh7th/vim-vsnip"}
    },
    config = function() require("config.cmp") end
  }

  use {
    "hrsh7th/vim-vsnip",
    config = function() require("config.vsnip") end
  }

  -- Used sometimes ===================================={{{2

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt" , "vim" }
    })
    end
  }

  -- Used for a markdown wiki.
  use {
    "jakewvincent/mkdnflow.nvim",
    config = function() require("config.mkdnflow") end
  }

  -- Show content of registers.
  use {
    "tversteeg/registers.nvim",
    config = function() require("registers").setup() end,
  }
  
  -- }}}2

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- vim specific options ===================================================={{{1
-- vim: set foldmethod=marker:
-- nvim: set foldmethod=marker:
