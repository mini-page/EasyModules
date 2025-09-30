# ═══════════════════════════════════════════════════════════════════════════════════
# PROFILE STATISTICS AND INFORMATION
# ═══════════════════════════════════════════════════════════════════════════════════

# Get profile loading performance
$profileLoadTime = if ($global:ProfileStartTime) {
    [math]::Round(((Get-Date) - $global:ProfileStartTime).TotalMilliseconds)
}
else { "Unknown" }

# Detect available package managers
$packageManagers = @()
if (Get-Command scoop -ErrorAction SilentlyContinue) { $packageManagers += "Scoop" }
if (Get-Command choco -ErrorAction SilentlyContinue) { $packageManagers += "Chocolatey" }
if (Get-Command winget -ErrorAction SilentlyContinue) { $packageManagers += "Winget" }
if (Get-Command npm -ErrorAction SilentlyContinue) { $packageManagers += "NPM" }
if (Get-Command pip -ErrorAction SilentlyContinue) { $packageManagers += "PIP" }
if ($packageManagers.Count -eq 0) { $packageManagers += "None detected" }

# Get system information
$psVersion = $PSVersionTable.PSVersion.ToString()
$osInfo = if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        "$($os.Caption) ($($os.Version))"
    }
    catch { "Windows" }
}
else { $PSVersionTable.OS }

# Count custom functions (exclude built-in and system functions)
$customFunctions = Get-Command -CommandType Function | Where-Object { 
    $_.Source -eq $null -and 
    $_.Name -notlike "prompt*" -and 
    $_.Name -notlike "TabExpansion*" -and
    $_.Name -notlike "Set-*" -and
    $_.Name -notlike "Get-*" -and
    $_.Name -notmatch "^[A-Z]:" -and
    $_.Name -notlike "Import-*" -and
    $_.Name -notlike "*:*"
}
$totalFunctions = $customFunctions.Count

# Count custom aliases (exclude built-in PowerShell aliases)
$builtInAliases = @('where', 'sort', 'tee', 'measure', 'select', 'group', 'compare', 'foreach', 'ft', 'fl', 'fw', 'gm', 'gc', 'gl', 'gp', 'gs', 'gv', 'gy', 'ii', 'iwr', 'ls', 'ps', 'pwd', 'r', 'rm', 'rmdir', 'echo', 'cls', 'chdir', 'copy', 'del', 'dir', 'erase', 'move', 'ren', 'set', 'type')
$customAliases = Get-Alias | Where-Object { 
    $_.Name -notin $builtInAliases -and 
    $_.Source -eq $null 
}
$totalAliases = $customAliases.Count

# Get memory usage
$memoryInfo = try {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    if ($os) {
        $freeGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
        $totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $usedPercent = [math]::Round((($totalGB - $freeGB) / $totalGB) * 100, 1)
        "$freeGB GB free of $totalGB GB ($usedPercent% used)"
    }
    else { "Available" }
}
catch { "Available" }

# ═══════════════════════════════════════════════════════════════════════════════════
# DISPLAY SECTION
# ═══════════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
Write-Host "║                              " -NoNewline -ForegroundColor DarkCyan
Write-Host "POWERSHELL PROFILE LOADED" -NoNewline -ForegroundColor Cyan
Write-Host "                         ║" -ForegroundColor DarkCyan
Write-Host "╠════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan

# System Information
Write-Host "║ " -NoNewline -ForegroundColor DarkCyan
Write-Host "SYSTEM INFO" -NoNewline -ForegroundColor Yellow
Write-Host (" " * 68) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   PowerShell: " -NoNewline -ForegroundColor DarkCyan
Write-Host $psVersion -NoNewline -ForegroundColor White
$padding = 65 - $psVersion.Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   OS: " -NoNewline -ForegroundColor DarkCyan
$osDisplay = if ($osInfo.Length -gt 60) { $osInfo.Substring(0, 60) + "..." } else { $osInfo }
Write-Host $osDisplay -NoNewline -ForegroundColor White
$padding = 73 - $osDisplay.Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   Memory: " -NoNewline -ForegroundColor DarkCyan
Write-Host $memoryInfo -NoNewline -ForegroundColor White
$padding = 69 - $memoryInfo.Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "╠════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan

# Profile Statistics
Write-Host "║ " -NoNewline -ForegroundColor DarkCyan
Write-Host "PROFILE STATISTICS" -NoNewline -ForegroundColor Yellow
Write-Host (" " * 61) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   Custom Functions: " -NoNewline -ForegroundColor DarkCyan
Write-Host $totalFunctions -NoNewline -ForegroundColor Green
$padding = 59 - $totalFunctions.ToString().Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   Custom Aliases: " -NoNewline -ForegroundColor DarkCyan
Write-Host $totalAliases -NoNewline -ForegroundColor Green
$padding = 61 - $totalAliases.ToString().Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   Package Managers: " -NoNewline -ForegroundColor DarkCyan
$pmDisplay = if ($packageManagers.Count -gt 0) { $packageManagers -join ", " } else { "None detected" }
Write-Host $pmDisplay -NoNewline -ForegroundColor Green
$padding = 59 - $pmDisplay.Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "║   Load Time: " -NoNewline -ForegroundColor DarkCyan
$loadDisplay = "${profileLoadTime}ms"
Write-Host $loadDisplay -NoNewline -ForegroundColor $(if ($profileLoadTime -ne "Unknown" -and $profileLoadTime -lt 500) { "Green" } elseif ($profileLoadTime -lt 1000) { "Yellow" } else { "Red" })
$padding = 66 - $loadDisplay.Length
Write-Host (" " * $padding) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

Write-Host "╠════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan

# Quick Commands Reference
Write-Host "║ " -NoNewline -ForegroundColor DarkCyan
Write-Host "QUICK COMMANDS" -NoNewline -ForegroundColor Yellow
Write-Host (" " * 65) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

$quickCommands = @(
    "help       - Show available commands", 
    "tools      - Check installed development tools",
    "optimize   - Complete system optimization",
    "update     - Update all package managers",
    "restart    - Restart terminal with options",
    "sys        - System information and stats"
)

foreach ($cmd in $quickCommands) {
    Write-Host "║   " -NoNewline -ForegroundColor DarkCyan
    $cmdParts = $cmd -split " - "
    Write-Host $cmdParts[0] -NoNewline -ForegroundColor Cyan
    Write-Host " - " -NoNewline -ForegroundColor DarkGray
    Write-Host $cmdParts[1] -NoNewline -ForegroundColor White
    $padding = 77 - $cmd.Length
    Write-Host (" " * $padding) -NoNewline
    Write-Host "║" -ForegroundColor DarkCyan
}

Write-Host "╠════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan

# Tips and Information
Write-Host "║ " -NoNewline -ForegroundColor DarkCyan
Write-Host "TIPS & SHORTCUTS" -NoNewline -ForegroundColor Yellow
Write-Host (" " * 63) -NoNewline
Write-Host "║" -ForegroundColor DarkCyan

$tips = @(
    "• Use Tab completion for all commands and parameters",
    "• Most commands support -Preview to see what they would do", 
    "• Chain commands: 'optimize; sys; update'",
    "• Type 'Get-Help <command> -Examples' for usage examples"
    
    # ---------- Startup Message ----------

    Write-Host "   → Type '" -ForegroundColor Gray -NoNewline
    Write-Host "help" -ForegroundColor Yellow -NoNewline
    Write-Host "' for Quick Reference" -ForegroundColor Gray

    Write-Host "   → Type '" -ForegroundColor Gray -NoNewline
    Write-Host "Get-Summary" -ForegroundColor Yellow -NoNewline
    Write-Host "' for Synopsis/Overview" -ForegroundColor Gray
)

foreach ($tip in $tips) {
    Write-Host "║   " -NoNewline -ForegroundColor DarkCyan
    Write-Host $tip -NoNewline -ForegroundColor White
    $padding = 77 - $tip.Length
    Write-Host (" " * $padding) -NoNewline
    Write-Host "║" -ForegroundColor DarkCyan
}

Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan

# Detect available features
$features = @()
$optionalTools = @{
    "winget" = "Winget"
    "scoop"  = "Scoop"
    "choco"  = "Chocolatey"
    "npm"    = "npm"
    "pip"    = "pip"
}

foreach ($tool in $optionalTools.Keys) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        $features += $optionalTools[$tool]
    }
}
# Return initialization status object (useful for scripts)
[PSCustomObject]@{
    Version  = $script:EasyCommandsVersion
    Aliases  = -not $NoAliases
    Features = $features
    Quiet    = $Quiet
    Status   = "Ready"
}