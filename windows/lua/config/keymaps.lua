-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

-- Helper function for window navigation
local function index_of(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then return i end
  end
end

-- Window navigation
vim.keymap.set("n", "<Tab>", function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur = vim.api.nvim_get_current_win()
  local idx = index_of(wins, cur)
  local next_win = wins[(idx % #wins) + 1]
  vim.api.nvim_set_current_win(next_win)
end, { desc = "Focus next window" })

vim.keymap.set("n", "<S-Tab>", function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur = vim.api.nvim_get_current_win()
  local idx = index_of(wins, cur)
  local prev_win = wins[(idx - 2) % #wins + 1]
  vim.api.nvim_set_current_win(prev_win)
end, { desc = "Focus previous window" })

-- Visual mode indent mappings (Custom Implementation)
local function custom_indent()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then vim.cmd('normal! \27') end
    
    local r1 = vim.fn.line("'<") - 1
    local r2 = vim.fn.line("'>") - 1
    local lines = vim.api.nvim_buf_get_lines(0, r1, r2 + 1, false)
    local shiftwidth = vim.fn.shiftwidth()
    local indent_str = vim.bo.expandtab and string.rep(" ", shiftwidth) or "\t"
    
    for i, line in ipairs(lines) do
        lines[i] = indent_str .. line
    end
    vim.api.nvim_buf_set_lines(0, r1, r2 + 1, false, lines)
    
    vim.api.nvim_win_set_cursor(0, {r1 + 1, 0})
    vim.cmd('normal! ' .. (mode == '\22' and '\22' or mode))
    vim.api.nvim_win_set_cursor(0, {r2 + 1, #lines[#lines]})
end

local function custom_unindent()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then vim.cmd('normal! \27') end
    
    local r1 = vim.fn.line("'<") - 1
    local r2 = vim.fn.line("'>") - 1
    local lines = vim.api.nvim_buf_get_lines(0, r1, r2 + 1, false)
    local shiftwidth = vim.fn.shiftwidth()
    local tab_str = "\t"
    local space_str = string.rep(" ", shiftwidth)
    
    for i, line in ipairs(lines) do
        if vim.startswith(line, space_str) then
            lines[i] = string.sub(line, #space_str + 1)
        elseif vim.startswith(line, tab_str) then
            lines[i] = string.sub(line, 2)
        else
            local spaces_removed = 0
            while spaces_removed < shiftwidth and vim.startswith(lines[i], " ") do
                lines[i] = string.sub(lines[i], 2)
                spaces_removed = spaces_removed + 1
            end
        end
    end
    vim.api.nvim_buf_set_lines(0, r1, r2 + 1, false, lines)
    
    vim.api.nvim_win_set_cursor(0, {r1 + 1, 0})
    vim.cmd('normal! ' .. (mode == '\22' and '\22' or mode))
    vim.api.nvim_win_set_cursor(0, {r2 + 1, #lines[#lines]})
end

-- Wrapped in VimEnter to clear UltiSnips and apply our custom Lua logic
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only unmap in Visual mode (x). Leave Select mode (s) intact so UltiSnips can jump between placeholders.
    pcall(vim.cmd, "xunmap <Tab>")
    pcall(vim.cmd, "xunmap <S-Tab>")
    
    -- Map specifically for 'x' (Visual) mode, NOT 'v' (Visual + Select) mode.
    vim.keymap.set('x', '<Tab>', custom_indent, { desc = 'Custom Indent' })
    vim.keymap.set('x', '<S-Tab>', custom_unindent, { desc = 'Custom Unindent' })
  end,
})

-- Smart wrapping of visual selection
local function wrap_selection(char)
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then
        vim.cmd('normal! \27')
    end

    local r1, c1 = vim.fn.line("'<") - 1, vim.fn.col("'<") - 1
    local r2, c2 = vim.fn.line("'>") - 1, vim.fn.col("'>")
    
    local lines = vim.api.nvim_buf_get_lines(0, r2, r2 + 1, false)
    local line_len = lines[1] and #lines[1] or 0
    if c2 > line_len then c2 = line_len end

    local text_parts = vim.api.nvim_buf_get_text(0, r1, c1, r2, c2, {})
    local text = table.concat(text_parts, "\n")
    
    if text == "" then return end

    local new_text = char .. text .. char
    local new_parts = vim.split(new_text, "\n")
    
    vim.api.nvim_buf_set_text(0, r1, c1, r2, c2, new_parts)

    local end_row = r1 + #new_parts - 1
    local end_col = (end_row == r1) and (c1 + #new_parts[1]) or #new_parts[#new_parts]

    vim.api.nvim_win_set_cursor(0, {r1 + 1, c1})
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, {end_row + 1, end_col - 1})
end

vim.keymap.set('v', "'", function() wrap_selection("'") end)
vim.keymap.set('v', '"', function() wrap_selection('"') end)
vim.keymap.set('v', '$', function() wrap_selection('$') end)

local function wrap_with_pairs(open_char, close_char)
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then
        vim.cmd('normal! \27')
    end

    local r1, c1 = vim.fn.line("'<") - 1, vim.fn.col("'<") - 1
    local r2, c2 = vim.fn.line("'>") - 1, vim.fn.col("'>")
    
    local lines = vim.api.nvim_buf_get_lines(0, r2, r2 + 1, false)
    local line_len = lines[1] and #lines[1] or 0
    if c2 > line_len then c2 = line_len end

    local text_parts = vim.api.nvim_buf_get_text(0, r1, c1, r2, c2, {})
    local text = table.concat(text_parts, "\n")
    
    if text == "" then return end

    local new_text = open_char .. text .. close_char
    local new_parts = vim.split(new_text, "\n")
    
    vim.api.nvim_buf_set_text(0, r1, c1, r2, c2, new_parts)

    local end_row = r1 + #new_parts - 1
    local end_col = (end_row == r1) and (c1 + #new_parts[1]) or #new_parts[#new_parts]

    vim.api.nvim_win_set_cursor(0, {r1 + 1, c1})
    vim.cmd('normal! v')
    vim.api.nvim_win_set_cursor(0, {end_row + 1, end_col - 1})
end

vim.keymap.set('v', '(', function() wrap_with_pairs('(', ')') end)
vim.keymap.set('v', '[', function() wrap_with_pairs('[', ']') end)
vim.keymap.set('v', '{', function() wrap_with_pairs('{', '}') end)

-- Spell checking
vim.api.nvim_set_keymap('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { noremap = true, silent = true })

-- LaTeX formatting
vim.keymap.set('v', '<M-b>', function() wrap_with_pairs('\\textbf{', '}') end)
vim.keymap.set('v', '<M-i>', function() wrap_with_pairs('\\textit{', '}') end)

-- LaTeX compilation
vim.api.nvim_set_keymap('n', '<C-o>', ':w<CR>:VimtexCompile<CR>', { noremap = true, silent = true })

-- Manim execution
vim.keymap.set("n", "<S-F5>", function()
  vim.cmd("write")
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t")
  local class = vim.fn.expand("%:t:r")
  local cmd = "cd " .. dir .. " && manim -pql " .. filename .. " " .. class
  vim.o.splitright = true
  vim.cmd("vsplit")
  vim.cmd("terminal " .. cmd)
end, { desc = "Run Manim scene", noremap = true, silent = true })
