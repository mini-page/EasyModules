# ==========================================================
# Shared Helper Functions module (Helpers.psm1)
# ==========================================================

function Write-Color {
    param(
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('Gray', 'DarkGray', 'Red', 'Green', 'Yellow', 'Cyan', 'Blue', 'Magenta', 'White')]
        [string]$Color = 'White',
        [switch]$NoNewLine
    )
    if ($NoNewLine) { 
        Write-Host -ForegroundColor $Color -NoNewline $Message 
    }
    else { 
        Write-Host -ForegroundColor $Color $Message 
    }
}

function Confirm-Action {
    param([string]$Message = "Proceed?", [switch]$AutoYes)
    if ($AutoYes) { return $true }
    $ans = Read-Host "$Message (Y/N)"
    return ($ans -match '^(?i)y(es)?$')
}

function Wait-Input {
    Read-Host "Press Enter to continue..." | Out-Null
}
