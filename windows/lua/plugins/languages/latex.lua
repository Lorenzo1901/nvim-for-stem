-- ============================================================================
-- LATEX LANGUAGE SUPPORT (with SumatraPDF)
-- ============================================================================

return {
  -- LaTeX support
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- Set the viewer to SumatraPDF.
      vim.g.vimtex_view_method = 'general'
      vim.g.vimtex_view_general_viewer = 'SumatraPDF.exe'
      vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      -- The auto-save feature from your original config.
      -- This is independent of the PDF viewer.
      vim.api.nvim_create_augroup("auto_save", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = "auto_save",
        pattern = "*.tex",
        callback = function()
          vim.cmd("silent! write")
        end,
      })
      vim.o.updatetime = 3000
    end
  },
}

