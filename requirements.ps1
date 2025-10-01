# requirements.ps1
# Script to install required tools with user consent

# Helper function: Ask yes/no
function Ask-Consent($msg) {
    $answer = Read-Host "$msg (y/n)"
    return $answer -match '^[Yy]'
}

# Ensure winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ Winget not found. Please install it manually from Microsoft Store." -ForegroundColor Yellow
    exit 1
}

# 1. Terminal Preview
if (Ask-Consent "Do you want to install Windows Terminal Preview?") {
    winget install --id Microsoft.WindowsTerminalPreview -e --source msstore
}

# 2. PowerShell 7
if (Ask-Consent "Do you want to install PowerShell 7?") {
    winget install --id Microsoft.Powershell -e
}

# 3. Python (latest stable)
if (Ask-Consent "Do you want to install Python (latest)?") {
    winget install --id Python.Python.3 -e
}

# 4. Git (optional)
if (Ask-Consent "Do you want to install Git?") {
    winget install --id Git.Git -e
}

# 5. Winget (redundant check, already needed)
Write-Host "✅ Winget is already available." -ForegroundColor Green

Write-Host "`n🎉 Setup complete! Restart terminal if needed." -ForegroundColor Cyan
