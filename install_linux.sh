#!/bin/bash

# ==============================================================================
# Neovim Configuration Installer for Linux
# Supports: Debian/Ubuntu (apt) and Arch Linux (pacman)
# ==============================================================================

set -e

echo "========================================"
echo " Neovim Environment Setup for Linux     "
echo "========================================"

echo ""
echo "[Configurazione Cartella di Lavoro]"
read -p "Inserisci il percorso di default per Nvim-Tree e FZF [~/Documents/uni]: " WORKSPACE_PATH
WORKSPACE_PATH=${WORKSPACE_PATH:-"~/Documents/uni"}
WORKSPACE_PATH=${WORKSPACE_PATH%/}

if [ -f "linux/lua/plugins/editor.lua" ]; then
    sed -i.bak "s|~/Documents/uni|$WORKSPACE_PATH|g" linux/lua/plugins/editor.lua
fi
if [ -f "linux/lua/plugins/ui.lua" ]; then
    sed -i.bak "s|~/Documents/uni/|$WORKSPACE_PATH/|g" linux/lua/plugins/ui.lua
fi
echo ""

if command -v pacman &> /dev/null; then
    echo "Detected Arch Linux (pacman)"
    echo "Installing system dependencies..."
    sudo pacman -Sy --needed neovim git base-devel nodejs npm python python-pip ripgrep fzf zathura zathura-pdf-mupdf xdotool texlive-meta texlab ffmpeg
    
    echo "Installing Python packages..."
    pip3 install --user --break-system-packages pynvim neovim-remote manim

elif command -v apt &> /dev/null; then
    echo "Detected Debian/Ubuntu (apt)"
    echo "Installing system dependencies..."
    sudo apt update
    sudo apt install -y neovim git build-essential nodejs npm python3 python3-pip ripgrep fzf zathura zathura-pdf-mupdf xdotool texlive-full ffmpeg

    # texlab is often missing from default apt repos in older versions, so we fetch it
    if ! command -v texlab &> /dev/null; then
        echo "Installing texlab from GitHub releases..."
        curl -L -o texlab.tar.gz "https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-linux.tar.gz"
        tar -xzf texlab.tar.gz
        sudo mv texlab /usr/local/bin/
        rm texlab.tar.gz
    fi

    echo "Installing Python packages..."
    pip3 install --user --break-system-packages pynvim neovim-remote manim || pip3 install --user pynvim neovim-remote manim
else
    echo "Unsupported package manager. Please install dependencies manually:"
    echo "neovim git build-essential nodejs npm python3 pip3 ripgrep fzf zathura texlive texlab ffmpeg"
    exit 1
fi

echo "========================================"
echo "Installation complete!"
echo "Make sure to copy the 'linux' folder contents to ~/.config/nvim/"
echo "Then, open Neovim to let lazy.nvim download all plugins."
echo "========================================"
