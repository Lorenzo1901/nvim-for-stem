# Neovim Configuration Guide

## Table of Contents

1. [Overview](#1-overview)
2. [Directory Structure](#2-directory-structure)
3. [General Settings](#3-general-settings)
4. [Key Features](#4-key-features)
5. [Complete Keymap Reference](#5-complete-keymap-reference)
6. [Plugin Categories](#6-plugin-categories)
7. [Language Support](#7-language-support)
8. [LaTeX Snippets Reference](#8-latex-snippets-reference)
9. [Quick Start Guide](#9-quick-start-guide)

---

### 1. Overview

Modern Neovim setup optimized for Windows and Linux, focused on LaTeX writing, Python development, and general text editing with:

- **Plugin Manager**: Lazy.nvim with lazy loading
- **Theme**: OneDark (warmer variant)
- **Leader Key**: `;` (semicolon)
- **Primary Use Cases**: LaTeX documents, Python code, Markdown writing, academic writing

**Key Integrations:**
- SumatraPDF (Windows) / Zathura (Linux) for LaTeX preview
- GitHub Copilot for AI assistance
- FZF for file searching
- LSP (Pyright, Texlab) for intelligent editing
- Treesitter for advanced syntax highlighting

---

### 2. Directory Structure

This repository contains two distinct configuration directories to provide tailored support for both operating systems:
- `linux/`: Configuration tailored for Linux environments (uses Zathura for PDF viewing, Unix paths, bash/zsh terminals).
- `windows/`: Configuration tailored for Windows environments (uses SumatraPDF for PDF viewing, Windows paths).

> **Note**: Both configurations are kept completely identical in terms of plugins, shortcuts, and features (including advanced Markdown preview, Treesitter syntax, and Python debugging). The only differences between the two are the absolute file paths and the PDF viewer setup.

---

### 3. General Settings

```lua
vim.g.mapleader = ";"                    -- Leader key
vim.opt.number = true                    -- Show line numbers
vim.opt.relativenumber = true            -- Relative line numbers
vim.opt.cursorline = true                -- Highlight current line
vim.opt.clipboard = "unnamedplus"        -- System clipboard
vim.opt.ignorecase = true                -- Case-insensitive search
vim.opt.smartcase = true                 -- Smart case when uppercase present
vim.opt.spell = false                    -- Spell check (Italian dictionary default)
vim.opt.spelllang = 'it'                 -- Italian dictionary
vim.opt.selection = "inclusive"
vim.opt.virtualedit = "onemore"
```

**Cursor Styles:**
- Normal/Visual: Thin vertical bar
- Insert: Thick vertical bar  
- Replace: Horizontal bar

---

### 4. Key Features

#### Dashboard (Alpha.nvim)
Custom ASCII art with quick actions upon launching Neovim:
- `f` - Find files in `~/Documents/` folder via FZF
- `r` - Recent files history
- `e` - Open a new empty buffer
- `c` - Open the Neovim configuration directory
- `u` - Update plugins via Lazy
- `q` - Quit Neovim

#### Smart Tab Behavior
The Tab key intelligently handles context:
1. UltiSnips expansion/navigation.
2. Completion menu navigation.
3. Regular tab functionality.
*(Note: GitHub Copilot uses `Alt-Space` instead of Tab to avoid conflicts).*

#### Auto-save for LaTeX
LaTeX files (`*.tex`) automatically save every 3 seconds of inactivity, triggering a re-render in the PDF viewer without manual intervention.

#### Code Folding
Uses Treesitter and indentation for intelligent code folding (via `nvim-ufo`), allowing you to cleanly collapse large functions and classes.

#### Markdown Live Preview
Integrated Markdown rendering directly inside the editor, plus browser-based live preview support.

---

### 5. Complete Keymap Reference

#### Dashboard Actions
| Key   | Action       | Description              |
|-------|--------------|--------------------------|
| `f`   | Find Files   | FZF search in Documents directory |
| `r`   | Recent Files | File history via FZF     |
| `e`   | New File     | Create new buffer        |
| `c`   | Config       | Open config directory via FZF |
| `u`   | Update       | Sync plugins via Lazy    |
| `q`   | Quit         | Exit Neovim              |

#### Navigation & Windows
| Key      | Mode   | Action           | Description              |
|----------|--------|------------------|--------------------------|
| `<Tab>`  | Normal | Window Navigation| Focus next window split  |
| `<S-Tab>`| Normal | Window Navigation| Focus previous window split |
| `<C-n>`  | Normal | File Tree        | Toggle nvim-tree in `~/Documents/uni/` |
| `<C-k>`  | Normal | Outline          | Toggle document outline  |

#### Text Editing (Visual Mode)
These shortcuts apply to the currently selected text without losing the visual selection.
| Key       | Mode   | Action       | Description          |
|-----------|--------|--------------|----------------------|
| `<Tab>`   | Visual | Indent       | Increase indent, keep selection |
| `<S-Tab>` | Visual | Unindent     | Decrease indent, keep selection |
| `'`       | Visual | Wrap Quotes  | Wrap selection in single quotes `'text'` |
| `"`       | Visual | Wrap Quotes  | Wrap selection in double quotes `"text"` |
| `$`       | Visual | Math Mode    | Wrap selection in LaTeX dollar signs `$text$` |
| `(`       | Visual | Wrap Parens  | Wrap selection in parentheses `(text)` |
| `[`       | Visual | Wrap Brackets| Wrap selection in square brackets `[text]` |
| `{`       | Visual | Wrap Braces  | Wrap selection in curly braces `{text}` |

#### LaTeX Specific
| Key      | Mode   | Action  | Description        |
|----------|--------|---------|--------------------|
| `<M-b>`  | Visual | Bold    | Wrap selection in `\textbf{}` |
| `<M-i>`  | Visual | Italic  | Wrap selection in `\textit{}` |
| `<C-o>`  | Normal | Compile | Save and trigger VimTeX compile |
| `<C-l>`  | Insert | Spell Fix | Auto-correct previous misspelled word |

#### Code Execution & Debugging
| Key       | Mode   | Action      | Description       |
|-----------|--------|-------------|-------------------|
| `<Leader>r` | Normal | Run Python  | Save and execute the python script in a right vertical split terminal |

#### Markdown
| Key         | Mode   | Action          | Description       |
|-------------|--------|-----------------|-------------------|
| `<Leader>mp`| Normal | Preview Toggle  | Toggle live Markdown preview in web browser |

#### Code Folding
| Key  | Mode   | Action    | Description       |
|------|--------|-----------|-------------------|
| `zR` | Normal | Open All  | Open all folds in the document |
| `zM` | Normal | Close All | Close all folds in the document |
| `za` | Normal | Toggle    | Toggle fold under the cursor |
| `zo` | Normal | Open      | Open fold under the cursor |
| `zc` | Normal | Close     | Close fold under the cursor |

#### Completion & Snippets
| Key       | Mode   | Action     | Description                    |
|-----------|--------|------------|-------------------------------|
| `<M-Space>`| Insert | Copilot   | Accept GitHub Copilot suggestion |
| `<Tab>`   | Insert | Snippets  | Expand snippet or jump to next snippet field |
| `<S-Tab>` | Insert | Previous   | Jump to previous snippet field |
| `<CR>`    | Insert | Confirm    | Confirm completion (without auto-selecting the first item) |
| `<C-j>`   | Insert | Next Item  | Move to next completion item |
| `<Up>`/`<Down>` | Insert | Navigate | Navigate through completion options |

---

### 6. Plugin Categories

#### UI & Appearance
- **alpha-nvim**: Custom dashboard with ASCII art and shortcuts.
- **onedark.nvim**: Theme (warmer variant).
- **lualine.nvim**: Status line with git branch, diagnostics, and file info.
- **indent-blankline.nvim**: Rainbow colored indent guides to easily match indentation levels.

#### File Management & Navigation
- **nvim-tree.lua**: File explorer sidebar (`Ctrl-N`).
- **fzf + fzf.vim**: Blazing fast fuzzy finder for files and buffers.
- **outline.nvim**: Document structure tree (`Ctrl-K`).

#### Code Editing & Highlighting
- **nvim-treesitter**: Advanced syntax highlighting and code parsing for accurate folding.
- **nvim-autopairs**: Auto-close brackets, quotes, and parentheses.
- **nvim-ufo**: Intelligent and ultra-fast code folding.
- **copilot.vim**: AI-powered code suggestions.

#### Completion System
- **nvim-cmp**: Highly customizable completion engine.
- **UltiSnips**: Snippet management system.
- Sources: LSP, buffer words, file paths, and command line history.

#### Utilities
- **render-markdown.nvim**: In-editor markdown rendering for headings, bullets, code blocks.
- **markdown-preview.nvim**: Browser-based live preview for markdown files.

---

### 7. Language Support

#### LaTeX (VimTeX + Texlab LSP)
**Setup Requirements:**
- LaTeX distribution (TeX Live / MiKTeX)
- **Linux:** Zathura PDF viewer
- **Windows:** SumatraPDF viewer
- Texlab LSP: `cargo install texlab`

**Features:**
- Auto-save and compile via `latexmk`.
- PDF preview with automatic SyncTeX (forward and inverse search).
- Custom highlight colors for math delimiters (`$`, `\[`, `\]`).
- Out-of-the-box snippet integration via UltiSnips.

#### Python (Pyright LSP + Black + DAP)
**Setup Requirements:**
- Python 3.x
- Pyright: `npm install -g pyright`
- Black formatter: `pip install black`

**Features:**
- Static type checking and autocompletion via Pyright.
- Auto-formatting on save via `conform.nvim` using Black.
- Split-terminal script execution using `<Leader>r`.
- DAP (Debug Adapter Protocol) support via `nvim-dap` and `nvim-dap-python` for step-by-step debugging.

#### Additional Languages
- **Markdown**: Full preview and in-editor rendering.
- **JavaScript/HTML/CSS**: Basic LSP and Treesitter syntax support.
- **Lua**: Dedicated support for editing Neovim configurations.

---

### 8. LaTeX Snippets Reference

The configuration includes a rich library of custom LaTeX snippets (`UltiSnips/tex.snippets`). Many snippets use **Auto-expand** (they trigger instantly without pressing `<Tab>`). Snippets marked with **Math Context** only trigger when inside a math environment (e.g., `$ ... $` or `\begin{equation}`).

#### Environments & Document Structure
| Trigger | Action | Context |
|---------|--------|---------|
| `template` | Basic LaTeX document template | Any |
| `beg` | `\begin{...} \end{...}` block | Any |
| `table` | Table environment | Any |
| `fig` | Figure environment | Any |
| `enum` | Enumerate environment | Any |
| `item` | Itemize environment | Any |
| `desc` | Description environment | Any |
| `pac` | `\usepackage{}` | Any |
| `case` | `\begin{cases}` | Any |
| `ali` | `\begin{align*}` | Any |
| `bigfun` | Big function map (`\begin{align*}`) | Any |
| `SI` | `\SI{value}{unit}` | Any |
| `letw` | "Let $\Omega \subset \mathbb{C}$ be open." | Any |

#### Math Mode Toggles
| Trigger | Action |
|---------|--------|
| `mk` | Inline math (`$ ... $`) |
| `dm` | Display math (`\[ ... \]` or `$$`) |

#### Symbols & Constants
| Trigger | Action | Context |
|---------|--------|---------|
| `ooo` | `\infty` | Math |
| `eps` | `\varepsilon` | Math |
| `lll` | `\ell` | Math |
| `nabl` | `\nabla` | Math |
| `**` | `\cdot` | Math |
| `xx` | `\times` | Math |

#### Math Text & Fonts
| Trigger | Action | Context |
|---------|--------|---------|
| `txt` | `\text{...}` | Any |
| `sts` | `_\text{...}` (Text subscript) | Any |
| `mcal` | `\mathcal{...}` | Math |
| `bf` | `\textbf{...}` | Math |

#### Automatic Fractions, Powers & Subscripts
| Trigger | Action | Context |
|---------|--------|---------|
| `//` | `\frac{...}{...}` | Math |
| `x/` | Converts `x/` to `\frac{x}{...}` | Math |
| `(x+y)/` | Converts `(x+y)/` to `\frac{x+y}{...}` | Math |
| `x1` | Converts to `x_1` (any letter + digit) | Any |
| `x_12` | Converts to `x_{12}` | Any |
| `__` | Subscript `_{...}` | Math |
| `td` | Superscript `^{...}` | Math |
| `sr` | Squared `^2` | Math |
| `cb` | Cubed `^3` | Math |
| `invs` | Inverse `^{-1}` | Math |
| `cmpl` | Complement `^{c}` | Math |
| `xnn` | `x_n` (also `ynn`, `xii`, `yii`, `xjj`, `yjj`, `xmm`) | Math |
| `xp1` | `x_{n+1}` | Math |

#### Logic & Relations
| Trigger | Action | Context |
|---------|--------|---------|
| `=>`, `=<` | `\implies`, `\impliedby` | Math |
| `iff` | `\iff` | Math |
| `==` | `&= ... \\` (Align equals) | Math |
| `!=` | `\neq` | Math |
| `<=`, `>=` | `\le`, `\ge` | Math |
| `>>`, `<<` | `\gg`, `\ll` | Math |
| `~~` | `\sim` | Math |
| `->`, `!>` | `\to`, `\mapsto` | Math |
| `<->` | `\leftrightarrow` | Math |
| `<!` | `\triangleleft` | Math |
| `<>` | `\diamond` | Math |

#### Sets & Operators
| Trigger | Action | Context |
|---------|--------|---------|
| `set` | `\{ ... \}` | Math |
| `inn`, `notin` | `\in`, `\not\in` | Math |
| `sbst` | `\subset` | Math |
| `Nn`, `UU` | `\cap`, `\cup` | Math |
| `nnn`, `uuu`| `\bigcap`, `\bigcup` | Math |
| `OO` | `\emptyset` | Math |
| `\\\` | `\setminus` | Math |
| `NN`, `RR`, `QQ`, `ZZ`, `DD`, `HH` | Blackboard bold `\mathbb{X}` | Math |
| `R0+` | `\mathbb{R}_0^+` | Math |
| `EE`, `AA`, `PP`, `Ee` | `\exists`, `\forall`, `\mathbb{P}`, `\mathbb{E}` | Math |

#### Calculus, Limits & Integrals
| Trigger | Action | Context |
|---------|--------|---------|
| `sum` | `\sum_{...}^{...}` | Math |
| `prod` | `\prod_{...}^{...}` | Math |
| `lim`, `limsup`| `\lim_{n \to \infty}`, `\limsup` | Math |
| `int` | `\int_{...}^{...}` | Math |
| `part` | `\frac{\partial ...}{\partial ...}` | Math |
| `taylor` | Taylor series expansion | Math |
| `sqrt` | `\sqrt{...}` | Math |

#### Brackets & Enclosures (Auto-expanding)
| Trigger | Action | Context |
|---------|--------|---------|
| `()`, `[]`, `{}` | `\left( \right)`, `\left[ \right]`, `\left\{ \right\}` | Math |
| `||` | `\left\| \right\|` | Math |
| `lra` | `\left< \right>` | Math |
| `ceil`, `floor`| `\left\lceil \right\rceil`, `\left\lfloor \right\rfloor`| Any |
| `norm` | `\| ... \|` | Math |
| `conj` | `\overline{...}` | Math |
| `bar`, `hat` | `\bar{...}`, `\hat{...}` (Auto-applied to previous character) | Math |

#### Matrices & Vectors
| Trigger | Action | Context |
|---------|--------|---------|
| `pmat`, `bmat` | `\begin{pmatrix}`, `\begin{bmatrix}` | Math |
| `cvec` | Column vector with `\vdots` | Math |
| `rij` | `(x_n)_{n \in \mathbb{N}}` | Math |

#### Auto-Triggers for Math Functions
When in **math mode**, typing any of these followed by a space or non-alphabet character will auto-escape them with a backslash (e.g. typing `sin` automatically becomes `\sin`):  
`sin`, `cos`, `arccot`, `cot`, `csc`, `ln`, `log`, `exp`, `star`, `perp`, `arcsin`, `arccos`, `arctan`, `pi`, `zeta`, `delta`, `kappa`, `lambda`, `mu`, `nu`, `rho`, `sigma`, `tau`, `omega`.

#### Plotting & External Computation
| Trigger | Action | Context |
|---------|--------|---------|
| `plot` | TikZ/PGFPlots 2D axis block | Any |
| `surf` | TikZ/PGFPlots 3D surface block | Any |
| `node` | TikZ node | Any |
| `sympy` | Evaluate mathematical expression using SymPy | Any |
| `math` | Evaluate mathematical expression using WolframScript | Any |

---

### 9. Quick Start Guide

#### Installation
Automated installation scripts are provided for all major operating systems. They will install Neovim, Git, Node.js, Python, LaTeX distributions, PDF viewers, and all necessary dependencies. They also install the required **RobotoMono Nerd Font**.
- **Windows:** Right-click `install_windows.ps1` and select "Run with PowerShell" (or execute it from a terminal). Make sure you have `winget` installed (it is usually pre-installed on modern Windows 10 and 11).
- **macOS:** Open a terminal and run `bash install_macos.sh`. It uses Homebrew under the hood.
- **Linux:** Open a terminal and run `bash install_linux.sh`. It automatically detects and supports `apt` (Ubuntu/Debian) and `pacman` (Arch Linux).

> **Important (Font Setup):** The installer downloads and installs the *RobotoMono Nerd Font* on your OS. However, Neovim runs inside your terminal. To see the icons properly, you **must configure your terminal emulator** (Windows Terminal, iTerm2, Kitty, Alacritty, etc.) to use `RobotoMono Nerd Font` as its default font.

After running the script, copy the contents of the respective OS folder (`windows`, `macos`, or `linux`) into your Neovim configuration directory:
- Windows: `%USERPROFILE%\AppData\Local\nvim\`
- macOS/Linux: `~/.config/nvim/`

#### First Launch
1. Open Neovim → The custom Dashboard appears.
2. Press `f` to find files using FZF, or `e` to start a new blank file.
3. Use `Ctrl-N` to toggle the file tree, `Ctrl-K` to see the document outline.

#### LaTeX Workflow
1. Create a `.tex` file.
2. Write content. The file automatically saves every 3 seconds.
3. Use `Ctrl-O` to force a compilation if needed.
4. The configured PDF viewer (Zathura/Sumatra) will open and sync with your cursor location.
5. Highlight text in Visual Mode and use `Alt-B` / `Alt-I` for bold/italic formatting, or `$` for math mode.

#### Python Development
1. Create a `.py` file.
2. Write code with Pyright LSP providing real-time checking and autocomplete.
3. Save the file: Black automatically formats your code to PEP-8 standards.
4. Press `;r` (Leader + r) to run the script in an integrated side terminal.

#### General Editing
1. `<Alt-Space>` accepts Copilot suggestions.
2. `Tab` expands snippets and moves between snippet placeholders.
3. In Visual mode, wrap texts instantly by selecting them and pressing `"`, `'`, `(`, `[`, or `{`.
4. Jump between window splits using `<Tab>` and `<Shift-Tab>`.

#### Plugin Management
- Type `:Lazy` to open the plugin manager interface.
- Type `:Lazy sync` to update and synchronize all installed plugins.
- Type `:checkhealth` to view Neovim diagnostic information and verify tool installations.

#### Customization
Depending on your OS, edit your configuration in the respective folder:
- **Linux:** `linux/init.lua`
- **Windows:** `windows/init.lua` (often linked to `C:/Users/Lorenzo/AppData/Local/nvim/init.lua`)

**Common Modifications:**
- Change the leader key: `lua/config/options.lua` -> `vim.g.mapleader`
- Add new keymaps: `lua/config/keymaps.lua`
- Modify theme or dashboard: `lua/plugins/ui.lua`
- Add a new language: `lua/plugins/languages/`

---

### Third-Party Plugin Disclaimer

The MIT license included in this repository applies **only to the configuration files and scripts** written here (e.g., `init.lua`, plugin settings, key mappings, installation scripts, snippets, etc.).

All third-party plugins referenced via the plugin manager (e.g., `lazy.nvim`, `vimtex`, `nvim-cmp`, etc.) are developed and maintained by their respective authors, and are **not included** in this repository nor covered by this license. Please refer to each plugin's own repository and license for their terms of use.
