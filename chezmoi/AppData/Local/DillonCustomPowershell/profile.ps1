if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
  oh-my-posh init pwsh --config "~\AppData\Local\DillonCustomPowershell\oh-my-posh\ys.omp.json" | Invoke-Expression
} else {
  Write-Host "Please run `winget install JanDeDobbeleer.OhMyPosh` to install oh-my-posh"
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else {
  Write-Host "Please run `winget install zoxide` to install zoxide"
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
  Set-Alias -Name ls -Value eza -Option AllScope
} else {
  Write-Host "Please run `winget install eza` to install eza"
}

# Alias grep to findstr only if grep isn't available:
if (-not (Get-Command grep -ErrorAction SilentlyContinue)) {
  Set-Alias -Name grep -Value findstr
}

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias -Name vim -Value nvim

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module ~\AppData\Local\DillonCustomPowershell\posh-git\src\posh-git.psd1
