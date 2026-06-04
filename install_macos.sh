#!/bin/bash

# ==============================================================================
# Neovim Configuration Installer for macOS
# Requirements: Homebrew installed
# ==============================================================================

set -e

echo "Select Language / Scegli la lingua: "
echo "1) English (Default)"
echo "2) Italiano"
read -p "> " LANG_CHOICE
LANG_CHOICE=${LANG_CHOICE:-1}

if [ "$LANG_CHOICE" = "2" ]; then
    MSG_TITLE="Configurazione Ambiente Neovim"
    MSG_WORK_DIR="[Configurazione Cartella di Lavoro]"
    MSG_WORK_PROMPT="Inserisci il percorso di default per Nvim-Tree e FZF [~/Documents/uni]: "
    MSG_BREW_MISSING="Homebrew non trovato. Installazione in corso..."
    MSG_SYS_DEP="Installazione dei pacchetti base tramite Homebrew..."
    MSG_MAC_DEP="Installazione di MacTeX e Skim (PDF Viewer per SyncTeX)..."
    MSG_PY_DEP="Installazione pacchetti Python necessari (pynvim, neovim-remote, manim)..."
    MSG_DONE="Installazione completata! Assicurati di fare queste cose:"
    MSG_COPY="1. Copiare il contenuto della cartella 'macos' dentro ~/.config/nvim/"
    MSG_OPEN="2. Aprire Neovim per scaricare i plugin via lazy.nvim."
    MSG_FONT_REMINDER="3. Impostare il font del terminale su 'RobotoMono Nerd Font'."
    MSG_ALREADY_INSTALLED="già installato, salto."
    MSG_INSTALLING="Installazione di"
    MSG_FONT_DEP="Installazione Roboto Mono Nerd Font..."
else
    MSG_TITLE="Neovim Environment Setup"
    MSG_WORK_DIR="[Workspace Directory Configuration]"
    MSG_WORK_PROMPT="Enter default path for Nvim-Tree and FZF [~/Documents/uni]: "
    MSG_BREW_MISSING="Homebrew not found. Installing..."
    MSG_SYS_DEP="Installing base packages via Homebrew..."
    MSG_MAC_DEP="Installing MacTeX and Skim (PDF Viewer for SyncTeX)..."
    MSG_PY_DEP="Installing Python packages (pynvim, neovim-remote, manim)..."
    MSG_DONE="Installation complete! Make sure to:"
    MSG_COPY="1. Copy the 'macos' folder contents to ~/.config/nvim/"
    MSG_OPEN="2. Open Neovim to let lazy.nvim download all plugins."
    MSG_FONT_REMINDER="3. Set your terminal font to 'RobotoMono Nerd Font'."
    MSG_ALREADY_INSTALLED="already installed, skipping."
    MSG_INSTALLING="Installing"
    MSG_FONT_DEP="Installing Roboto Mono Nerd Font..."
fi

echo "========================================"
echo " $MSG_TITLE "
echo "========================================"

echo ""
echo "$MSG_WORK_DIR"
read -p "$MSG_WORK_PROMPT" WORKSPACE_PATH
WORKSPACE_PATH=${WORKSPACE_PATH:-"~/Documents/uni"}
WORKSPACE_PATH=${WORKSPACE_PATH%/}

if [ -f "macos/lua/plugins/editor.lua" ]; then
    sed -i.bak "s|~/Documents/uni|$WORKSPACE_PATH|g" macos/lua/plugins/editor.lua
fi
if [ -f "macos/lua/plugins/ui.lua" ]; then
    sed -i.bak "s|~/Documents/uni/|$WORKSPACE_PATH/|g" macos/lua/plugins/ui.lua
fi
echo ""

if ! command -v brew &> /dev/null; then
    echo "$MSG_BREW_MISSING"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "$MSG_SYS_DEP"
for pkg in neovim git node python ripgrep fzf texlab ffmpeg; do
    if brew list "$pkg" &> /dev/null; then
        echo "- $pkg $MSG_ALREADY_INSTALLED"
    else
        echo "$MSG_INSTALLING $pkg..."
        brew install "$pkg"
    fi
done

echo "$MSG_MAC_DEP"
for cask in mactex skim; do
    if brew list --cask "$cask" &> /dev/null; then
        echo "- $cask $MSG_ALREADY_INSTALLED"
    else
        echo "$MSG_INSTALLING $cask..."
        brew install --cask "$cask"
    fi
done

echo "$MSG_PY_DEP"
pip3 install --user --break-system-packages pynvim neovim-remote manim black || pip3 install --user pynvim neovim-remote manim black

if command -v npm &> /dev/null; then
    echo "$MSG_INSTALLING Pyright (LSP)..."
    npm install -g pyright
fi

echo ""
echo "$MSG_FONT_DEP"
if brew list --cask font-roboto-mono-nerd-font &> /dev/null; then
    echo "- font-roboto-mono-nerd-font $MSG_ALREADY_INSTALLED"
else
    echo "$MSG_INSTALLING font-roboto-mono-nerd-font..."
    brew install --cask font-roboto-mono-nerd-font
fi

echo "========================================"
echo "$MSG_DONE"
echo "$MSG_COPY"
echo "$MSG_OPEN"
echo "$MSG_FONT_REMINDER"
echo "========================================"
