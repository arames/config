local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap

-- Disable unwanted built-in use ---------------------------------------{{{1
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'shada_plugin',
  'tar',
  'tarPlugin',
  'zip',
  'zipPlugin',
}

for i = 1, #disabled_built_ins do
  g['loaded_' .. disabled_built_ins[i]] = 1
end

-- Packer Bootstrap --------------------------------------------------------{{{1

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Plugins -----------------------------------------------------------------{{{1

-- See `lua/config/*` for per-plugin configuration.

return require('packer').startup(function(use)
  -- Used frequently --------------------------------------{{{2

  -- Packer can manage itself.
  use 'wbthomason/packer.nvim'

  -- Easily navigate between tmux panes and vim instances.
  use 'christoomey/vim-tmux-navigator'

  -- Better status line.
  use 'vim-airline/vim-airline'

  -- Quickly move around.
  use {'phaazon/hop.nvim', config=[[require('config.hop')]] }

  -- Git integration.
  use 'tpope/vim-fugitive'

  -- Easy parenthesis and co.
  use 'tpope/vim-surround'

  -- Case-sensitive search and replace (and more!).
  use 'tpope/vim-abolish'

  -- TODO: Fix config
  -- Easily jump to diff blobs.
  use 'arames/vim-diffgofile'

  -- Display color codes.
  use {'norcalli/nvim-colorizer.lua',
       config = [[require('colorizer').setup({'*';}, {mode = 'foreground'})]]
     }

  -- Allow "editing" the quickfix window.
  use 'jceb/vim-editqf'

  use {'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
    },
    run = ':TSUpdate',
    config = [[require('config.treesitter')]],
  }


  -- Mostly used as a quick way to invoke `fzf`. Much more powerful however.
  use {'nvim-telescope/telescope.nvim',
       requires = {'nvim-lua/plenary.nvim'},
       config = [[require('config.telescope')]],
     }

  use {'nvim-telescope/telescope-fzf-native.nvim',
       after = 'telescope.nvim',
       config = [[require('telescope').load_extension('fzf')]],
       run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
     }

  use {'neovim/nvim-lspconfig',
       config = [[require('config.nvim_lspconfig')]],
       after = 'cmp-nvim-lsp'
     }

  use {'hrsh7th/cmp-nvim-lsp',
       requires = {
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-path',
         'hrsh7th/nvim-cmp',
       },
       config = [[require('config.cmp-nvim-lsp')]],
     }

  use {'windwp/nvim-autopairs',
       config = [[require('config.nvim-autopairs')]],
       after = 'cmp-nvim-lsp'
     }

  use 'hrsh7th/cmp-vsnip'
  use {'hrsh7th/vim-vsnip',
       config = [[require('config.vim-vsnip')]]
     }


  -- Testing =============================================={{{2

  --use { 'nvim-telescope/telescope-frecency.nvim',
  --config = function()
  --  require"telescope".load_extension("frecency")
  --end,
  --requires = {"tami5/sqlite.lua"}
  --}



  -- Packer Bootstrap -------------------------------------{{{2
  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- .vimrc specific options -------------------------------------------------{{{1
-- vim: set foldmethod=marker:
-- nvim: set foldmethod=marker:
