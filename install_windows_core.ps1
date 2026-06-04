# Rimuove il blocco di sicurezza del file se scaricato da internet
if ($MyInvocation.MyCommand.Path -and (Test-Path $MyInvocation.MyCommand.Path)) { Unblock-File -Path $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue }

# ==============================================================================
# Neovim Configuration Installer for Windows
# Requirements: Windows 10/11 with Winget installed
# ==============================================================================

Write-Host "Select Language / Scegli la lingua:" -ForegroundColor Cyan
Write-Host "1) English (Default)"
Write-Host "2) Italiano"
$langChoice = Read-Host ">"

if ($langChoice -eq "2") {
    $MSG_TITLE = "Configurazione Ambiente Neovim"
    $MSG_WORK_DIR = "[Configurazione Cartella di Lavoro]"
    $MSG_WORK_PROMPT = "Inserisci il percorso di default per Nvim-Tree e FZF (premi Invio per '~/Documents/uni')"
    $MSG_WINGET_ERR = "Winget non trovato! Assicurati di avere App Installer aggiornato dallo Store."
    $MSG_STEP1 = "[1/4] Installazione dei pacchetti base tramite Winget..."
    $MSG_STEP2 = "[2/4] Installazione di Texlab (LaTeX LSP)..."
    $MSG_STEP3 = "[3/4] Installazione dei pacchetti Python (pynvim, neovim-remote, manim)..."
    $MSG_STEP4 = "[4/4] Applicazione Fix e Installazione Font (Roboto Mono)..."
    $MSG_DONE = "Installazione completata!"
    $MSG_DONE = "Installazione completata! Ricordati di impostare 'RobotoMono Nerd Font' nel tuo terminale."
    $MSG_DONE1 = "1. Riavviare il terminale per caricare i nuovi percorsi nel PATH."
    $MSG_DONE2 = "2. Copiare il contenuto della cartella 'windows' dentro '$env:USERPROFILE\AppData\Local\nvim\'"
    $MSG_DONE3 = "3. Aprire Neovim per scaricare i plugin via lazy.nvim."
    $MSG_DONE4 = "4. Impostare il font del terminale su 'RobotoMono Nerd Font' per vedere le icone."
    $MSG_ALREADY_INSTALLED = "già installato, salto."
    $MSG_INSTALLING = "Installazione di"
    $MSG_DOWNLOADING = "Scaricando"
    $MSG_FIX_CURL = "Aggiunto Git curl al PATH utente per risolvere errori di certificato (Soluzione 2)."
    $MSG_FONT_DONE = "Font installato."
    $MSG_SKIPPED = "Saltato (già installato)"
    $MSG_RESTART = "NOTA: Potrebbe essere necessario riavviare il terminale per far funzionare alcuni comandi (come python o npm)."
    $MSG_COPY_CONFIG = "Copia della configurazione di Neovim in ~/AppData/Local/nvim..."
} else {
    $MSG_TITLE = "Neovim Environment Installer"
    $MSG_WORK_DIR = "[Workspace Directory Configuration]"
    $MSG_WORK_PROMPT = "Enter default path for Nvim-Tree and FZF (press Enter for '~/Documents/uni')"
    $MSG_WINGET_ERR = "Winget not found! Make sure App Installer is updated from the Store."
    $MSG_STEP1 = "[1/4] Installing base packages via Winget..."
    $MSG_STEP2 = "[2/4] Installing Texlab (LaTeX LSP)..."
    $MSG_STEP3 = "[3/4] Installing Python packages (pynvim, neovim-remote, manim)..."
    $MSG_STEP4 = "[4/4] Applying Fixes and Installing Font (Roboto Mono)..."
    $MSG_DONE = "Installation complete! Remember to set 'RobotoMono Nerd Font' in your terminal."
    $MSG_DONE1 = "1. Restart the terminal to load new PATH variables."
    $MSG_DONE2 = "2. Copy the 'windows' folder contents into '$env:USERPROFILE\AppData\Local\nvim\'"
    $MSG_DONE3 = "3. Open Neovim to download plugins via lazy.nvim."
    $MSG_DONE4 = "4. Set your terminal font to 'RobotoMono Nerd Font' to see icons properly."
    $MSG_ALREADY_INSTALLED = "already installed, skipping."
    $MSG_INSTALLING = "Installing"
    $MSG_DOWNLOADING = "Downloading"
    $MSG_FIX_CURL = "Added Git curl to user PATH to fix certificate errors (Solution 2)."
    $MSG_FONT_DONE = "Font installed."
    $MSG_SKIPPED = "Skipped (already installed)"
    $MSG_RESTART = "NOTE: You may need to restart your terminal for some commands (like python or npm) to work."
    $MSG_COPY_CONFIG = "Copying Neovim configuration to ~/AppData/Local/nvim..."
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " $MSG_TITLE   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n$MSG_WORK_DIR" -ForegroundColor Yellow
$workspacePath = Read-Host $MSG_WORK_PROMPT
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
    Write-Host $MSG_WINGET_ERR -ForegroundColor Red
    exit 1
}

$packages = @(
    @("Neovim.Neovim", "nvim"),
    @("Git.Git", "git"),
    @("OpenJS.NodeJS", "node"),
    @("Python.Python.3.11", "python"),
    @("GNU.Ripgrep", "rg"),
    @("SumatraPDF.SumatraPDF", "SumatraPDF"),
    @("MiKTeX.MiKTeX", "pdflatex"),
    @("Gyan.FFmpeg", "ffmpeg"),
    @("LLVM.LLVM", "clang")
)

Write-Host "`n$MSG_STEP1" -ForegroundColor Yellow
foreach ($pkgPair in $packages) {
    $pkgId = $pkgPair[0]
    $cmd = $pkgPair[1]
    
    # Check if command exists or package is installed
    $isInstalled = $false
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $isInstalled = $true
    } elseif ($cmd -eq "SumatraPDF" -and (Test-Path "$env:LOCALAPPDATA\SumatraPDF\SumatraPDF.exe")) {
        $isInstalled = $true
    }
    
    if ($isInstalled) {
        Write-Host "- $pkgId $MSG_ALREADY_INSTALLED" -ForegroundColor DarkGray
    } else {
        Write-Host "$MSG_INSTALLING $pkgId..."
        winget install --id $pkgId -e --accept-package-agreements --accept-source-agreements
    }
}

Write-Host "`n$MSG_STEP2" -ForegroundColor Yellow
$texlabPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\texlab.exe"
if (!(Test-Path $texlabPath) -and !(Get-Command texlab -ErrorAction SilentlyContinue)) {
    Write-Host "$MSG_DOWNLOADING texlab..."
    $url = "https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-windows.zip"
    $zipFile = "$env:TEMP\texlab.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath "$env:TEMP\texlab" -Force
    Move-Item -Path "$env:TEMP\texlab\texlab.exe" -Destination $texlabPath -Force
    Remove-Item -Path $zipFile
    Remove-Item -Path "$env:TEMP\texlab" -Recurse -Force
} else {
    Write-Host "- texlab $MSG_ALREADY_INSTALLED" -ForegroundColor DarkGray
}

Write-Host "`n$MSG_STEP3" -ForegroundColor Yellow
# Cerchiamo di usare Python 3.11 (se disponibile tramite py launcher) per evitare problemi di compilazione con Python 3.14+
$pyExe = "python"
$pyArgs = @()
if (Get-Command py -ErrorAction SilentlyContinue) {
    py -3.11 --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $pyExe = "py"
        $pyArgs = @("-3.11")
        Write-Host "Trovato Python 3.11 (tramite py launcher), lo utilizzo per pip..." -ForegroundColor Green
    }
}

if ($pyExe -eq "python") {
    $fallbackPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
        "$env:ProgramFiles\Python311\python.exe",
        "$env:ProgramFiles\Python312\python.exe"
    )
    foreach ($p in $fallbackPaths) {
        if (Test-Path $p) {
            $pyExe = $p
            Write-Host "Trovato Python compatibile in $p, lo utilizzo per pip..." -ForegroundColor Green
            break
        }
    }
}

& $pyExe $pyArgs -m pip install --no-cache-dir --upgrade pip | Out-Null
$pyPackages = @("pynvim", "neovim-remote", "manim", "black")
foreach ($pyPkg in $pyPackages) {
    $pipShow = & $pyExe $pyArgs -m pip show $pyPkg 2>$null
    if ($pipShow) {
        Write-Host "- $pyPkg $MSG_ALREADY_INSTALLED" -ForegroundColor DarkGray
    } else {
        Write-Host "$MSG_INSTALLING $pyPkg..."
        & $pyExe $pyArgs -m pip install --no-cache-dir $pyPkg
    }
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Get-Command pyright -ErrorAction SilentlyContinue) {
        Write-Host "- pyright $MSG_SKIPPED" -ForegroundColor DarkGray
    } else {
        Write-Host "`n$MSG_INSTALLING Pyright (LSP)..." -ForegroundColor Yellow
        npm install -g pyright
    }
    if (Get-Command tree-sitter -ErrorAction SilentlyContinue) {
        Write-Host "- tree-sitter $MSG_SKIPPED" -ForegroundColor DarkGray
    } else {
        Write-Host "`n$MSG_INSTALLING tree-sitter-cli..." -ForegroundColor Yellow
        npm install -g tree-sitter-cli
    }
}

Write-Host "`n$MSG_STEP4" -ForegroundColor Yellow
# FIX CURL (Solution 2)
$gitBinPath = "$env:ProgramFiles\Git\mingw64\bin"
if (Test-Path "$gitBinPath\curl.exe") {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$gitBinPath*") {
        [Environment]::SetEnvironmentVariable("Path", "$gitBinPath;$userPath", "User")
        Write-Host $MSG_FIX_CURL -ForegroundColor Green
    }
}

# INSTALL FONT
Write-Host "$MSG_INSTALLING RobotoMono Nerd Font..."
$fontDir = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
if (!(Test-Path $fontDir)) { New-Item -ItemType Directory -Path $fontDir | Out-Null }
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip"
$zipFile = "$env:TEMP\RobotoMono.zip"
$extractDir = "$env:TEMP\RobotoMono"
if (!(Test-Path "$fontDir\RobotoMonoNerdFont-Regular.ttf")) {
    Invoke-WebRequest -Uri $fontUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force
    foreach ($font in Get-ChildItem -Path $extractDir -Filter "*.ttf") {
        $targetPath = "$fontDir\$($font.Name)"
        if (!(Test-Path $targetPath)) {
            Copy-Item -Path $font.FullName -Destination $targetPath
            New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $font.Name.Replace(".ttf", " (TrueType)") -Value $targetPath -PropertyType String -Force | Out-Null
        }
    }
    Remove-Item -Path $zipFile -Force
    Remove-Item -Path $extractDir -Recurse -Force
    Write-Host $MSG_FONT_DONE -ForegroundColor Green
} else {
    Write-Host "- Roboto Mono Nerd Font $MSG_SKIPPED" -ForegroundColor DarkGray
}

Write-Host "`n$MSG_COPY_CONFIG" -ForegroundColor Yellow
$nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
if (!(Test-Path $nvimDir)) {
    New-Item -ItemType Directory -Force -Path $nvimDir | Out-Null
}
$windowsConfigPath = Join-Path -Path $PSScriptRoot -ChildPath "windows"
if (Test-Path $windowsConfigPath) {
    Copy-Item -Path "$windowsConfigPath\*" -Destination $nvimDir -Recurse -Force
    Write-Host "- OK" -ForegroundColor Green
} else {
    Write-Host "Warning: 'windows' directory not found. Please copy the configuration manually." -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host $MSG_DONE -ForegroundColor Green
Write-Host "Assicurati di / Make sure to:"
Write-Host $MSG_DONE1
Write-Host $MSG_DONE3
Write-Host $MSG_DONE4
Write-Host "========================================" -ForegroundColor Cyan
