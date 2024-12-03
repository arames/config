local lazypath = vim.g.pluginInstallPath .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  root = vim.g.pluginInstallPath,  -- The plugin folder is shared with `vim-plug`.
  spec = {
    { import = "plugins" },
    LazyPlugSpecs,
  },
  checker = { enabled = true }, -- Automatically check for plugin updates.
  performance = {
    rtp = {
      reset = false,
      disabled_plugins = {
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
    },
    reset_packpath = false,
  }
})
