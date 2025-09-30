# ==========================================================
# EasyModules Summary & Help
# ==========================================================

function Get-Summary {
    <#
    .SYNOPSIS
    Display summary of EasyCommands module
    .DESCRIPTION
    Shows comprehensive information about loaded functions and features
    .EXAMPLE
    Get-EasyCommandsSummary
    Show module summary
    #>
    
    Write-Host ""
    Write-Host "📋 v3.8.4 Module Summary" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════" -ForegroundColor DarkGray
    
    $categories = @{
        "System & Performance" = @('sys', 'get-performance', 'optimize')
        "Network Tools"        = @('net')
        "Package Management"   = @('update', 'apps')
        "System Maintenance"   = @('clean', 'optimize')
        "Development Tools"    = @('tools')
        "Terminal Control"     = @('restart', 'reload-profile', 'edit-profile', 'edit-commands')
        "Interactive"          = @('menu', 'help')
    }
    
    # Add conditional categories
    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        $categories["FZF Tools"] = @('fz-history', 'fz-dir', 'fz-process')
    }
    
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $categories["Git Integration"] = @('git-status', 'git-quick')
    }
    
    Write-Host ""
    foreach ($category in $categories.GetEnumerator()) {
        Write-Host "  $($category.Key):" -ForegroundColor Yellow
        foreach ($func in $category.Value) {
            if (Get-Command $func -ErrorAction SilentlyContinue) {
                Write-Host "    ✅ $func" -ForegroundColor Green
            }
            else {
                Write-Host "    ❌ $func (not available)" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
    }
}

function help {
    <#
    .SYNOPSIS
    Show EasyCommands guide
    .DESCRIPTION
    Displays a comprehensive list of commands, their parameters, usage, and examples.
    Supports:
      - Full manual
      - Single-command help
      - Compact list overview
    .PARAMETER Command
    Specific command to display help for
    .PARAMETER List
    Show compact list of all commands
    .EXAMPLE
    help
    Show full guide
    .EXAMPLE
    help sys
    Show detailed help for "sys"
    .EXAMPLE
    help -List
    Show compact command list
    #>
    
    param(
        [string]$Command,
        [switch]$List
    )

    $commands = @(
        @{
            Cmd     = "sys"
            Desc    = "Complete system information and performance snapshot"
            Params  = @(
                "-Quick   → Show only essential details",
                "-Export  → Export report to a file"
            )
            Usage   = "sys [-Quick] [-Export 'C:\path\report.txt']"
            Example = @(
                "sys -Quick",
                "sys -Export 'C:\Reports\sysinfo.txt'"
            )
        },
        @{
            Cmd     = "net"
            Desc    = "Complete network information and diagnostics"
            Params  = @(
                "-Public  → Show public IP details",
                "-Test    → Run basic connectivity test (ping)",
                "-Flush   → Clear DNS cache"
            )
            Usage   = "net [-Public] [-Test] [-Flush]"
            Example = @(
                "net -Public",
                "net -Test; net -Flush"
            )
        },
        @{
            Cmd     = "update"
            Desc    = "Universal package manager updater"
            Params  = @(
                "-winget → Update via Winget only",
                "-scoop  → Update via Scoop only",
                "-choco  → Update via Chocolatey only",
                "-AutoYes    → Skip confirmation prompts"
            )
            Usage   = "update [-winget] [-scoop] [-choco] [-AutoYes]"
            Example = @(
                "update",
                "update -winget -AutoYes"
            )
        },
        @{
            Cmd     = "apps"
            Desc    = "List installed applications from all sources"
            Params  = @(
                "-Source All|Winget|Scoop|Choco|Registry",
                "-Export   → Save list to a file"
            )
            Usage   = "apps [-Source All|Winget|Scoop|Choco|Registry] [-Export path]"
            Example = @(
                "apps -Source Winget",
                "apps -Source All -Export 'C:\apps.csv'"
            )
        },
        @{
            Cmd     = "optimize"
            Desc    = "Quick system optimization"
            Params  = @(
                "-Preview → Show what would be cleaned",
                "-Quick    → Quick cleanup Of system"
            )
            Usage   = "optimize [-Preview] [-Quick]"
            Example = @(
                "optimize",
                "optimize -Preview",
                "optimize -Quick"
            )
        },
        @{
            Cmd     = "tools"
            Desc    = "Check and manage development tools"
            Params  = @(
                "-Install <toolname> → Install a tool (e.g. git, node, python)",
                "-Check tool1,tool2  → Verify tools are installed"
            )
            Usage   = "tools [-Install git] [-Check node,python]"
            Example = @(
                "tools -Check git,node",
                "tools -Install python"
            )
        },
        @{
            Cmd     = "restart"
            Desc    = "Smart terminal restart"
            Params  = @(
                "-Here   → Restart in current directory",
                "-Force  → Skip confirmation"
            )
            Usage   = "restart [-Here] [-Force]"
            Example = @(
                "restart",
                "restart -Here -Force"
            )
        },
        @{
            Cmd     = "menu"
            Desc    = "Interactive command menu"
            Params  = @("(No params)")
            Usage   = "menu"
            Example = @("menu")
        },
        @{
            Cmd     = "help"
            Desc    = "Show this help information"
            Params  = @("(No params) or help <command> or help -List")
            Usage   = "help [command] | -List"
            Example = @("help", "help sys", "help -List")
        }
    )

    function Show-CommandDetails($cmd) {
        Write-Host ""
        Write-Host "▶ " -NoNewline -ForegroundColor DarkGray
        Write-Host $cmd.Cmd -ForegroundColor Green -NoNewline
        Write-Host " - " -NoNewline -ForegroundColor Gray
        Write-Host $cmd.Desc -ForegroundColor White

        if ($cmd.Params.Count -gt 0) {
            Write-Host "    Parameters:" -ForegroundColor DarkGray
            foreach ($p in $cmd.Params) {
                Write-Host "      $p" -ForegroundColor Cyan
            }
        }

        if ($cmd.Usage) {
            Write-Host "    Usage: " -NoNewline -ForegroundColor DarkGray
            Write-Host $cmd.Usage -ForegroundColor DarkCyan
        }

        if ($cmd.Example.Count -gt 0) {
            Write-Host "    Examples:" -ForegroundColor DarkGray
            foreach ($ex in $cmd.Example) {
                Write-Host "      $ex" -ForegroundColor Magenta
            }
        }
        Write-Host ""
    }

    if ($List) {
        Write-Host ""
        Write-Color "⚡ EasyCommands v3.8.4 - Command List" Cyan
        Write-Color "════════════════════════════════════════════════" DarkGray
        foreach ($cmd in $commands) {
            Write-Host ("• " + $cmd.Cmd.PadRight(10)) -ForegroundColor Green -NoNewline
            Write-Host $cmd.Desc -ForegroundColor White
        }
        Write-Host ""
        return
    }

    if ($Command) {
        $found = $commands | Where-Object { $_.Cmd -eq $Command }
        if ($found) {
            Write-Color "⚡ EasyCommands - Help for '$Command'" Cyan
            Write-Color "════════════════════════════════════════════════" DarkGray
            Show-CommandDetails $found
        }
        else {
            Write-Color "❌ Unknown command: $Command" Red
            Write-Host "Use 'help' to see all available commands."
        }
        return
    }

    # Full guide
    Write-Host ""
    Write-Color "⚡ EasyCommands v3.8.4 - User Guide" Cyan
    Write-Color "════════════════════════════════════════════════" DarkGray
    Write-Host ""

    Write-Host "📚 Commands:" -ForegroundColor Yellow
    foreach ($cmd in $commands) {
        Show-CommandDetails $cmd
    }

    Write-Host ""
    Write-Color "💡 Pro Tips:" Yellow
    Write-Host "• Use 'Get-Help <command> -Full' for PowerShell native help"
    Write-Host "• Most commands support -WhatIf or -Preview to simulate actions"
    Write-Host "• Use 'menu' for an interactive interface"
    Write-Host "• Commands can be chained: clean; optimize; sys -Quick"
    Write-Host ""
    Write-Color "════════════════════════════════════════════════" DarkGray
    Write-Host ""
}
