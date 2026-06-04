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
    $MSG_MSVC = "[+] Installazione Visual Studio Build Tools (Compilatore C/C++)..."
    $MSG_MSVC_WAIT = "Scaricamento e installazione in corso (~3GB). Attendi..."
    $MSG_STEP2 = "[2/4] Installazione di Texlab (LaTeX LSP)..."
    $MSG_STEP3 = "[3/4] Installazione dei pacchetti Python (pynvim, neovim-remote, manim, black)..."
    $MSG_STEP4 = "[4/4] Installazione Font (Roboto Mono)..."
    $MSG_DONE = "Installazione completata! Ricordati di impostare 'RobotoMono Nerd Font' nel tuo terminale."
    $MSG_DONE1 = "1. Riavviare il terminale per caricare i nuovi percorsi nel PATH."
    $MSG_DONE2 = "2. Copiare il contenuto della cartella 'windows' dentro '$env:USERPROFILE\AppData\Local\nvim\'"
    $MSG_DONE3 = "3. Aprire Neovim per scaricare i plugin via lazy.nvim."
    $MSG_DONE4 = "4. Impostare il font del terminale su 'RobotoMono Nerd Font' per vedere le icone."
    $MSG_ALREADY_INSTALLED = "già installato, salto."
    $MSG_INSTALLING = "Installazione di"
    $MSG_DOWNLOADING = "Scaricando"
    $MSG_FONT_DONE = "Font installato."
    $MSG_SKIPPED = "Saltato (già installato)"
    $MSG_COPY_CONFIG = "Copia della configurazione di Neovim in ~/AppData/Local/nvim..."
} else {
    $MSG_TITLE = "Neovim Environment Installer"
    $MSG_WORK_DIR = "[Workspace Directory Configuration]"
    $MSG_WORK_PROMPT = "Enter default path for Nvim-Tree and FZF (press Enter for '~/Documents/uni')"
    $MSG_WINGET_ERR = "Winget not found! Make sure App Installer is updated from the Store."
    $MSG_STEP1 = "[1/4] Installing base packages via Winget..."
    $MSG_MSVC = "[+] Installing Visual Studio Build Tools (C/C++ Compiler)..."
    $MSG_MSVC_WAIT = "Downloading and installing (~3GB). Please wait..."
    $MSG_STEP2 = "[2/4] Installing Texlab (LaTeX LSP)..."
    $MSG_STEP3 = "[3/4] Installing Python packages (pynvim, neovim-remote, manim, black)..."
    $MSG_STEP4 = "[4/4] Installing Font (Roboto Mono)..."
    $MSG_DONE = "Installation complete! Remember to set 'RobotoMono Nerd Font' in your terminal."
    $MSG_DONE1 = "1. Restart the terminal to load new PATH variables."
    $MSG_DONE2 = "2. Copy the 'windows' folder contents into '$env:USERPROFILE\AppData\Local\nvim\'"
    $MSG_DONE3 = "3. Open Neovim to download plugins via lazy.nvim."
    $MSG_DONE4 = "4. Set your terminal font to 'RobotoMono Nerd Font' to see icons properly."
    $MSG_ALREADY_INSTALLED = "already installed, skipping."
    $MSG_INSTALLING = "Installing"
    $MSG_DOWNLOADING = "Downloading"
    $MSG_FONT_DONE = "Font installed."
    $MSG_SKIPPED = "Skipped (already installed)"
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
    @("Gyan.FFmpeg", "ffmpeg")
)

Write-Host "`n$MSG_STEP1" -ForegroundColor Yellow
foreach ($pkgPair in $packages) {
    $pkgId = $pkgPair[0]
    $cmd = $pkgPair[1]
    
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

Write-Host "`n$MSG_MSVC" -ForegroundColor Yellow
$msvcFound = $false
$msvcPaths = @(
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC"
)
foreach ($p in $msvcPaths) {
    if (Test-Path $p) {
        $msvcFound = $true
        break
    }
}

if (!$msvcFound) {
    Write-Host $MSG_MSVC_WAIT -ForegroundColor Cyan
    winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--wait --quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" -e --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "- Visual Studio Build Tools / MSVC $MSG_ALREADY_INSTALLED" -ForegroundColor DarkGray
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

# Reload Path to ensure python/winget tools are available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

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
        $found = Get-ChildItem -Path $root -Filter "python.exe" -Recurse -ErrorAction SilentlyContinue |
                 Where-Object {
                     $v = & $_.FullName --version 2>&1
                     $v -match "^Python 3\.(11|12)\."
                 } | Select-Object -First 1
        if ($found) { return $found.FullName }
    }

    if (Get-Command py -ErrorAction SilentlyContinue) {
        foreach ($ver in @("3.11", "3.12")) {
            $check = & py "-$ver" --version 2>&1
            if ($LASTEXITCODE -eq 0) { return "py:-$ver" }
        }
    }

    return $null
}

$pyExe  = $null
$pyArgs = @()

$result = Find-Python311
if ($result) {
    if ($result -like "py:*") {
        $pyExe  = "py"
        $pyArgs = @($result.Split(":")[1])
        Write-Host "Trovato Python $($pyArgs[0]) tramite py launcher." -ForegroundColor Green
    } else {
        $pyExe = $result
        $pyVer = & $pyExe --version 2>&1
        Write-Host "Trovato $pyVer in: $pyExe" -ForegroundColor Green
    }
} else {
    Write-Host "Python 3.11 non trovato nel sistema. Installazione tramite winget..." -ForegroundColor Yellow
    winget install --id Python.Python.3.11 -e --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
    $result = Find-Python311
    if ($result -and $result -notlike "py:*") {
        $pyExe = $result
    } elseif ($result -like "py:*") {
        $pyExe  = "py"
        $pyArgs = @($result.Split(":")[1])
    } else {
        $defaultPath = "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe"
        if (Test-Path $defaultPath) {
            $pyExe = $defaultPath
        } else {
            Write-Host "ERRORE: Python 3.11 non installabile automaticamente." -ForegroundColor Red
            $pyExe = "python"
        }
    }
}

& $pyExe @pyArgs -m pip install --no-cache-dir --upgrade pip | Out-Null

$pyPackages = @("pynvim", "neovim-remote", "manim", "black")
foreach ($pyPkg in $pyPackages) {
    $pipShow = & $pyExe @pyArgs -m pip show $pyPkg 2>$null
    if ($pipShow) {
        Write-Host "- $pyPkg $MSG_ALREADY_INSTALLED" -ForegroundColor DarkGray
    } else {
        Write-Host "$MSG_INSTALLING $pyPkg..."
        & $pyExe @pyArgs -m pip install --no-cache-dir $pyPkg
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
