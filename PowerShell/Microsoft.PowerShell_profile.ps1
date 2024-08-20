<#
    .SYNOPSIS
    Burke's PowerShell Terminal Profile
    
    .DESCRIPTION
    The code contained below should be placed in the following locations:
    $HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1 -- for VS Code PowerShell Terminal
    $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -- for PowerShell Core (7.x) Terminal
    $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -- for Microsoft PowerShell 5.1
#>

$MaximumHistoryCount = 5000

# Autocomplete
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Historico
$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

#if (Get-Command lsd -ErrorAction SilentlyContinue){
#  Set-Alias -Name ls -Value lsd -Option AllScope
#}

if (Get-Command kubectl -ErrorAction SilentlyContinue) {
  # If the kubectl command is found, add command completion
  kubectl completion powershell | Out-String | Invoke-Expression
}

if (Get-Command helm -ErrorAction SilentlyContinue) {
  # If the kubectl command is found, add command completion
  helm completion powershell | Out-String | Invoke-Expression
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# Uncomment the following 4 lines to enable command completion for chocolatey. Warning: Increases initial PS load time
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}

if (Get-Command starship -ErrorAction SilentlyContinue) {
  # If the starship command is found, add the prompt with 
  # the default config stored in $HOME/.config/starship.toml
  # Override by setting env:
  $ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml" 
  function Invoke-Starship-TransientFunction {
    &starship module character
  }
  
  Invoke-Expression (&starship init powershell)
  
  Enable-TransientPrompt
}