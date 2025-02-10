vim.opt.termguicolors = true
vim.cmd.colorscheme("onedark_vivid")

require("nvim-autopairs").setup()

require"nvim-treesitter.configs".setup
{
  highlight =
  {
    enable = true,
  },
}
