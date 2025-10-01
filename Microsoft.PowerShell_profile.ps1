# ============================================
# PowerShell Profile
# Colorful • Interactive • Safe • Fast
# ============================================

# ---------- Core Initialization ----------
# oh-my-posh (theme)
try {
    oh-my-posh init pwsh --config "$env:USERPROFILE\Documents\PowerShell\theme\highContext.omp.json" | Invoke-Expression
}
catch {
    Write-Host "⚠️ oh-my-posh not loaded" -ForegroundColor DarkYellow
}

# Initialize zoxide (smart cd)
try {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
catch {
    Write-Host "⚠️ zoxide not loaded" -ForegroundColor DarkYellow
}

# ---------- Module Loading ----------
# Load modules quietly if present, show which succeed
$modules = @(
    # Visual / Prompt Enhancements
    'Terminal-Icons',                           # Adds file/folder icons to Get-ChildItem
    'posh-git',                                 # Git status info in prompt
    'Get-ChildItemColor',                       # LS-like command with colors

    # System / Windows
    'PSWindowsUpdate',                          # Manage Windows Updates from PowerShell
    'BurntToast',                               # Send Windows toast notifications
    'PSScriptAnalyzer',                         # Lint/analyze PowerShell scripts for issues

    # Navigation / Productivity
    'PSFzf',                                    # Fuzzy search for history, files, commands
    'PSReadLine',                               # Enhanced command editing & history (usually built-in)

    # Networking / Remote
    'Posh-SSH'                                  # SSH, SCP, SFTP support directly in PowerShell
)

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module $module -Scope CurrentUser -Force
    }
    Import-Module $module -ErrorAction SilentlyContinue
    Write-Host "✅ $module loaded" -ForegroundColor Green
}




# ---------- PSReadLine Configuration ----------
# Modern + Useful PSReadLine Config
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -MaximumHistoryCount 1000
#Set-PSReadLineOption -HistorySavePath "$env:USERPROFILE\Documents\PowerShell\txt files\PSReadLineHistory.txt"
Set-PSReadLineOption -Colors @{ "InlinePrediction" = "$([char]27)[90m" }

# Key bindings
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord


#univrsal helpers for other functions to run repeated things
Import-Module "$HOME\Documents\PowerShell\EasyModules\Helpers\helpers.psm1"

# ---------- Load Custom Functions ----------
$easyFuncsPath = "$env:USERPROFILE\Documents\PowerShell\EasyModules"

if (Test-Path $easyFuncsPath) {
    $files = Get-ChildItem -Path $easyFuncsPath -Filter *.ps1 -File
    foreach ($file in $files) {
        try {
            $time = Measure-Command { . $file.FullName }
            Write-Host "✅ $($file.BaseName) loaded in $([math]::Round($time.TotalMilliseconds,2)) ms" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Failed to load $($file.Name): $_" -ForegroundColor Red
        }
    }
}
else {
    Write-Host "⚠️ EasyModules folder not found at: $easyFuncsPath" -ForegroundColor Yellow
}




# ---------- Aliases ----------
# Keep minimal and DRY

