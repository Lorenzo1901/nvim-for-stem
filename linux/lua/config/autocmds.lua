-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Custom highlights and colors (deferred)
vim.schedule(function()
    -- Current line number color
    vim.cmd([[
        highlight CursorLineNr guifg=#f48c06
    ]])

    -- LaTeX math delimiters highlighting
    vim.api.nvim_set_hl(0, "TexMathDelimiter", { fg = "#bb70d2" })
    vim.api.nvim_set_hl(0, "texLigature", { link = "Normal" })
end)

-- LaTeX-specific autocmd
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = {"*.tex", "*.md"},
  callback = function()
    vim.fn.matchadd("TexMathDelimiter", [[\\\[\|\\\]\|\$]], 10)
  end,
})
