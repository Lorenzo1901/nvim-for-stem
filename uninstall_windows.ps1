# ==============================================================================
# Neovim Configuration Uninstaller for Windows
# ==============================================================================

Write-Host "Select Language / Scegli la lingua:" -ForegroundColor Cyan
Write-Host "1) English (Default)"
Write-Host "2) Italiano"
$langChoice = Read-Host ">"

if ($langChoice -eq "2") {
    $MSG_TITLE = "Disinstallazione Ambiente Neovim"
    $MSG_PROMPT = "Vuoi disinstallare"
    $MSG_WINGET = "Rimozione pacchetti base Winget..."
    $MSG_TEXLAB = "Rimozione Texlab (LaTeX LSP)..."
    $MSG_PIP = "Rimozione pacchetti Python (pip)..."
    $MSG_NPM = "Rimozione pacchetti Node (npm)..."
    $MSG_FONT = "Rimozione Roboto Mono Nerd Font..."
    $MSG_CONFIG = "Rimozione file di configurazione e dati locali di Neovim..."
    $MSG_DONE = "Disinstallazione completata!"
    $MSG_YESNO = "[y/n]"
    $MSG_REMOVED = "Rimosso"
    $MSG_SKIPPED = "Saltato"
    $MSG_NOT_FOUND = "non trovato"
} else {
    $MSG_TITLE = "Neovim Environment Uninstaller"
    $MSG_PROMPT = "Do you want to uninstall"
    $MSG_WINGET = "Removing base Winget packages..."
    $MSG_TEXLAB = "Removing Texlab (LaTeX LSP)..."
    $MSG_PIP = "Removing Python packages (pip)..."
    $MSG_NPM = "Removing Node packages (npm)..."
    $MSG_FONT = "Removing Roboto Mono Nerd Font..."
    $MSG_CONFIG = "Removing Neovim config and local data..."
    $MSG_DONE = "Uninstallation complete!"
    $MSG_YESNO = "[y/n]"
    $MSG_REMOVED = "Removed"
    $MSG_SKIPPED = "Skipped"
    $MSG_NOT_FOUND = "not found"
}

function Ask-Permission {
    param([string]$PromptMessage)
    while ($true) {
        $yn = Read-Host "$PromptMessage $MSG_YESNO"
        if ($yn -match "^[Yy]") { return $true }
        if ($yn -match "^[Nn]") { return $false }
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " $MSG_TITLE " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n$MSG_WINGET" -ForegroundColor Yellow
$packages = @(
    @("Neovim.Neovim", "nvim"),
    @("GNU.Ripgrep", "rg"),
    @("SumatraPDF.SumatraPDF", "SumatraPDF"),
    @("MiKTeX.MiKTeX", "pdflatex"),
    @("Gyan.FFmpeg", "ffmpeg")
)

foreach ($pkgPair in $packages) {
    $pkgId = $pkgPair[0]
    if (Ask-Permission "$MSG_PROMPT $pkgId?") {
        winget uninstall --id $pkgId
        Write-Host "- $pkgId $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- $pkgId $MSG_SKIPPED" -ForegroundColor DarkGray
    }
}

Write-Host "`n$MSG_TEXLAB" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT texlab?") {
    $texlabPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\texlab.exe"
    if (Test-Path $texlabPath) {
        Remove-Item -Path $texlabPath -Force
        Write-Host "- texlab $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- texlab $MSG_NOT_FOUND" -ForegroundColor DarkGray
    }
} else {
    Write-Host "- texlab $MSG_SKIPPED" -ForegroundColor DarkGray
}

Write-Host "`n$MSG_PIP" -ForegroundColor Yellow
$pyPackages = @("pynvim", "neovim-remote", "manim", "black")
foreach ($pyPkg in $pyPackages) {
    if (Ask-Permission "$MSG_PROMPT $pyPkg (pip)?") {
        python -m pip uninstall -y $pyPkg | Out-Null
        Write-Host "- $pyPkg $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- $pyPkg $MSG_SKIPPED" -ForegroundColor DarkGray
    }
}

Write-Host "`n$MSG_NPM" -ForegroundColor Yellow
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Ask-Permission "$MSG_PROMPT pyright (npm)?") {
        npm uninstall -g pyright
        Write-Host "- pyright $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- pyright $MSG_SKIPPED" -ForegroundColor DarkGray
    }
}

Write-Host "`n$MSG_FONT" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT Roboto Mono Nerd Font?") {
    $fontDir = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
    $fontRemoved = $false
    if (Test-Path "$fontDir\RobotoMonoNerdFont-Regular.ttf") {
        foreach ($font in Get-ChildItem -Path $fontDir -Filter "RobotoMono*.ttf") {
            Remove-Item -Path $font.FullName -Force
            Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $font.Name.Replace(".ttf", " (TrueType)") -ErrorAction SilentlyContinue
            $fontRemoved = $true
        }
    }
    if ($fontRemoved) {
        Write-Host "- Roboto Mono Nerd Font $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- Roboto Mono Nerd Font $MSG_NOT_FOUND" -ForegroundColor DarkGray
    }
} else {
    Write-Host "- Roboto Mono Nerd Font $MSG_SKIPPED" -ForegroundColor DarkGray
}

Write-Host "`n$MSG_CONFIG" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT Neovim config (~/AppData/Local/nvim)?") {
    $nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
    if (Test-Path $nvimDir) {
        Remove-Item -Path $nvimDir -Recurse -Force
        Write-Host "- nvim config $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- nvim config $MSG_NOT_FOUND" -ForegroundColor DarkGray
    }
} else {
    Write-Host "- nvim config $MSG_SKIPPED" -ForegroundColor DarkGray
}

if (Ask-Permission "$MSG_PROMPT Neovim local data (~/AppData/Local/nvim-data)?") {
    $nvimDataDir = "$env:USERPROFILE\AppData\Local\nvim-data"
    if (Test-Path $nvimDataDir) {
        Remove-Item -Path $nvimDataDir -Recurse -Force
        Write-Host "- nvim-data $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- nvim-data $MSG_NOT_FOUND" -ForegroundColor DarkGray
    }
} else {
    Write-Host "- nvim-data $MSG_SKIPPED" -ForegroundColor DarkGray
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host $MSG_DONE -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
