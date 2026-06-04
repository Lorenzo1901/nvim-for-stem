# ==============================================================================
# Neovim Configuration Installer for Windows
# Requirements: Windows 10/11 with Winget installed
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Neovim Environment Setup for Windows   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n[Configurazione Cartella di Lavoro]" -ForegroundColor Yellow
$workspacePath = Read-Host "Inserisci il percorso di default per Nvim-Tree e FZF (premi Invio per '~/Documents/uni')"
if ([string]::IsNullOrWhiteSpace($workspacePath)) {
    $workspacePath = "~/Documents/uni"
}
$workspacePath = $workspacePath.TrimEnd('/')

$editorFile = "windows\lua\plugins\editor.lua"
$uiFile = "windows\lua\plugins\ui.lua"

if (Test-Path $editorFile) {
    (Get-Content $editorFile) -replace '~/Documents/uni', $workspacePath | Set-Content $editorFile
}
if (Test-Path $uiFile) {
    (Get-Content $uiFile) -replace '~/Documents/uni/', "$workspacePath/" | Set-Content $uiFile
}

# Ensure winget is available
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget non trovato! Assicurati di avere App Installer aggiornato dallo Store." -ForegroundColor Red
    exit 1
}

$packages = @(
    "Neovim.Neovim",
    "Git.Git",
    "OpenJS.NodeJS",
    "Python.Python.3.11",
    "GNU.Ripgrep",
    "SumatraPDF.SumatraPDF",
    "MiKTeX.MiKTeX",
    "Gyan.FFmpeg"
)

Write-Host "`n[1/4] Installazione dei pacchetti base tramite Winget..." -ForegroundColor Yellow
foreach ($pkg in $packages) {
    Write-Host "Installando $pkg..."
    winget install --id $pkg -e --accept-package-agreements --accept-source-agreements
}

Write-Host "`n[2/4] Installazione di Texlab (LaTeX LSP)..." -ForegroundColor Yellow
$texlabPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\texlab.exe"
if (!(Test-Path $texlabPath)) {
    Write-Host "Scaricando texlab..."
    $url = "https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-windows.zip"
    $zipFile = "$env:TEMP\texlab.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath "$env:TEMP\texlab" -Force
    Move-Item -Path "$env:TEMP\texlab\texlab.exe" -Destination $texlabPath -Force
    Remove-Item -Path $zipFile
    Remove-Item -Path "$env:TEMP\texlab" -Recurse -Force
} else {
    Write-Host "Texlab già installato."
}

Write-Host "`n[3/4] Installazione dei pacchetti Python (pynvim, neovim-remote, manim)..." -ForegroundColor Yellow
# Update pip first
python -m pip install --upgrade pip
python -m pip install pynvim neovim-remote manim

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Installazione completata!" -ForegroundColor Green
Write-Host "Assicurati di:"
Write-Host "1. Riavviare il terminale per caricare i nuovi percorsi nel PATH."
Write-Host "2. Copiare il contenuto della cartella 'windows' dentro '$env:USERPROFILE\AppData\Local\nvim\'"
Write-Host "3. Aprire Neovim per scaricare i plugin via lazy.nvim."
Write-Host "========================================" -ForegroundColor Cyan
