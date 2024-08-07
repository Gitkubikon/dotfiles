-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.cmd([[autocmd FocusLost * silent! wa]])

lvim.plugins = {
  { 'AlphaTechnolog/pywal.nvim' },
  { 'marko-cerovac/material.nvim' },
  { "lunarvim/colorschemes" },
  { "github/copilot.vim" },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = { enabled = false },
      })
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",   -- lazy-load on filetype
    config = true, -- run require("neorg").setup()
  },
}

-- lvim.colorscheme = "material-deep-ocean"
lvim.colorscheme = "pywal"
