-- ============================================================================
-- LATEX LANGUAGE SUPPORT (with Zathura)
-- ============================================================================

return {
  -- LaTeX support
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- Viewer settings (Zathura)
      -- 'zathura_simple' skips xdotool (which fails on Wayland) and prevents 
      -- the "cannot find Zathura window ID" warning.
      vim.g.vimtex_view_method = 'zathura_simple'

      -- Fix inverse search (Ctrl+Click in PDF) on Wayland:
      -- Prevent Zathura from spawning full headless Neovim instances that load 
      -- LSP/Node workers (causing RAM leaks). We enforce a minimal Neovim 
      -- instance that loads ONLY VimTeX, making inverse search instant.
      vim.g.vimtex_callback_progpath = "nvim --clean --cmd 'set rtp+=~/.local/share/nvim/lazy/vimtex'"

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

