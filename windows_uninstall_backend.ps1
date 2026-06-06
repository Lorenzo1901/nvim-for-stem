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
    $MSG_MSVC = "Rimozione Visual Studio Build Tools (attenzione, pesano ~3GB e potrebbero servire ad altro)..."
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
    $MSG_MSVC = "Removing Visual Studio Build Tools (warning, they are ~3GB and might be used by other tools)..."
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

$pkgNames = ($packages | ForEach-Object { $_[0] }) -join ', '
Write-Host "I seguenti pacchetti verranno richiesti: $pkgNames" -ForegroundColor Cyan

foreach ($pkgPair in $packages) {
    $pkgId = $pkgPair[0]
    if (Ask-Permission "$MSG_PROMPT $pkgId?") {
        winget uninstall --id $pkgId
        Write-Host "- $pkgId $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- $pkgId $MSG_SKIPPED" -ForegroundColor DarkGray
    }
}

Write-Host "`n$MSG_MSVC" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT Microsoft.VisualStudio.2022.BuildTools (C/C++ Compiler)?") {
    winget uninstall --id Microsoft.VisualStudio.2022.BuildTools
    Write-Host "- Build Tools $MSG_REMOVED" -ForegroundColor Green
} else {
    Write-Host "- Build Tools $MSG_SKIPPED" -ForegroundColor DarkGray
}

Write-Host "`n$MSG_TEXLAB" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT texlab?") {
    $texlabPath = "$env:USERPROFILE\AppData\Local\bin\texlab.exe"
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

function Find-Python311 {
    $directPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
        "$env:ProgramFiles\Python311\python.exe",
        "${env:ProgramFiles(x86)}\Python311\python.exe"
    )
    foreach ($p in $directPaths) {
        if (Test-Path $p) { return $p }
    }

    $searchRoots = @(
        "$env:LOCALAPPDATA\Programs",
        "$env:ProgramFiles",
        "${env:ProgramFiles(x86)}"
    )
    foreach ($root in $searchRoots) {
        if (Test-Path $root) {
            $found = Get-ChildItem -Path $root -Filter "Python*" -Directory -ErrorAction SilentlyContinue |
                     Get-ChildItem -Filter "python.exe" -Recurse -ErrorAction SilentlyContinue |
                     Where-Object {
                         $v = & $_.FullName --version 2>&1
                         $v -match "^Python 3\.(11|12)\."
                     } | Select-Object -First 1
            if ($found) { return $found.FullName }
        }
    }

    if (Get-Command py -ErrorAction SilentlyContinue) {
        foreach ($ver in @("3.11", "3.12")) {
            $check = & py "-$ver" --version 2>&1
            if ($LASTEXITCODE -eq 0) { return "py:-$ver" }
        }
    }
    return $null
}

$pyExe  = "python"
$pyArgs = @()
$result = Find-Python311
if ($result) {
    if ($result -like "py:*") {
        $pyExe  = "py"
        $pyArgs = @($result.Split(":")[1])
    } else {
        $pyExe = $result
    }
}

$pyPackages = @("pynvim", "neovim-remote", "manim", "black")
foreach ($pyPkg in $pyPackages) {
    if (Ask-Permission "$MSG_PROMPT $pyPkg (pip)?") {
        & $pyExe @pyArgs -m pip uninstall -y $pyPkg | Out-Null
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
    if (Ask-Permission "$MSG_PROMPT tree-sitter-cli (npm)?") {
        npm uninstall -g tree-sitter-cli
        Write-Host "- tree-sitter-cli $MSG_REMOVED" -ForegroundColor Green
    } else {
        Write-Host "- tree-sitter-cli $MSG_SKIPPED" -ForegroundColor DarkGray
    }
}

Write-Host "`n$MSG_FONT" -ForegroundColor Yellow
if (Ask-Permission "$MSG_PROMPT Roboto Mono Nerd Font?") {
    $fontDir = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
    $fontRemoved = $false
    $fontInUse = $false
    if (Test-Path "$fontDir\RobotoMonoNerdFont-Regular.ttf") {
        foreach ($font in Get-ChildItem -Path $fontDir -Filter "RobotoMono*.ttf") {
            try {
                Remove-Item -Path $font.FullName -Force -ErrorAction Stop
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $font.Name.Replace(".ttf", " (TrueType)") -ErrorAction SilentlyContinue
                $fontRemoved = $true
            } catch {
                $fontInUse = $true
            }
        }
    }
    if ($fontInUse) {
        Write-Host "- Impossibile rimuovere il font perché è in uso dal terminale corrente. Chiudi il terminale e cancellalo manualmente da $fontDir." -ForegroundColor Red
    } elseif ($fontRemoved) {
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
