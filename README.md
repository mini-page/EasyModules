# PowerShell Profile Repository

  This repository contains a personalized configuration for a PowerShell environment. It includes custom
  scripts, installed modules, and theming configurations to enhance the command-line experience.

  ## Overview

  The setup is orchestrated through the main Microsoft.PowerShell_profile.ps1 script, which loads various
  modules and custom functions at the start of each session.

  ## Directory Structure

  - `Microsoft.PowerShell_profile.ps1`: The main PowerShell profile script that runs on startup.
  - `powershell.config.json`: Configuration file for PowerShell.
  - `.git/`: Contains the Git repository data for version control.
  - `EasyModules/`: A collection of custom PowerShell scripts and helper functions that provide personalized
  commands and utilities. Examples include:
    - Sys-Maintanance.ps1: Scripts for system maintenance tasks.
    - Get-AppsInfo.ps1: Scripts to retrieve information about installed applications.
    - Update-Apps.ps1: Scripts for updating applications.
    - Helpers/: Contains helper modules (.psm1) used by other scripts.
  - `Modules/`: Contains third-party modules installed to extend PowerShell's functionality. Key modules
  include:
    - `oh-my-posh`: A powerful theme engine for the PowerShell prompt.
    - `posh-git`: Provides Git status integration in the prompt.
    - `PSScriptAnalyzer`: A static code checker for PowerShell modules and scripts.
    - `PSReadLine`: Enhances the command-line editing experience in PowerShell.
  - `theme/`: Stores custom themes, in this case for oh-my-posh (highContext.omp.json).
  - `Help/`: Caches updatable help files for installed PowerShell modules.
  - `Scripts/`: Contains installed scripts and related information.
  - `txt files/`: A directory for miscellaneous text files, including PSReadLineHistory.txt, which stores the
   user's command history.

  ## Key Components & Customizations

  - Prompt Theming: The prompt is customized using `oh-my-posh` with the theme defined in
  theme/highContext.omp.json.
  - Git Integration: `posh-git` provides real-time feedback on Git repositories directly within the prompt.
  - Custom Functions: The EasyModules directory provides a suite of custom tools for managing the local
  system.

  ## Usage

  This repository is a personal configuration. To use a similar setup, another user would need to:
  1.  Clone the repository.
  2.  Ensure the PowerShell execution policy allows for running local scripts.
  3.  Review and potentially modify the Microsoft.PowerShell_profile.ps1 to fit their own environment and
