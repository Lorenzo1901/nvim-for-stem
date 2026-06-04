#!/bin/bash

# ==============================================================================
# Neovim Configuration Installer for macOS
# Requirements: Homebrew installed
# ==============================================================================

set -e

echo "========================================"
echo " Neovim Environment Setup for macOS     "
echo "========================================"

echo ""
echo "[Configurazione Cartella di Lavoro]"
read -p "Inserisci il percorso di default per Nvim-Tree e FZF [~/Documents/uni]: " WORKSPACE_PATH
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
    echo "Homebrew non trovato. Installazione in corso..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installazione dei pacchetti base tramite Homebrew..."
brew install neovim git node python ripgrep fzf texlab ffmpeg

echo "Installazione di MacTeX e Skim (PDF Viewer per SyncTeX)..."
brew install --cask mactex skim

echo "Installazione pacchetti Python necessari (pynvim, neovim-remote, manim)..."
pip3 install --user --break-system-packages pynvim neovim-remote manim || pip3 install --user pynvim neovim-remote manim

echo "========================================"
echo "Installazione completata!"
echo "Assicurati di copiare il contenuto della cartella 'macos' dentro ~/.config/nvim/"
echo "Successivamente, apri Neovim per scaricare i plugin via lazy.nvim."
echo "========================================"
