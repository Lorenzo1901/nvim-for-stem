-- ============================================================================
-- TREESITTER PLUGIN
-- ============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    config = function()
      vim.treesitter.language.register("latex", { "tex" })

      require('nvim-treesitter').install({ "lua", "python", "javascript", "html", "css", "latex" })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { "lua", "python", "javascript", "html", "css", "tex" },
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          
          if ev.match == "tex" then
            vim.bo[ev.buf].syntax = "tex"
          end
        end,
      })
    end
  },
}
