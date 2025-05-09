if (Get-Command oh-my-posh) {
  oh-my-posh init pwsh --config "~\AppData\Local\DillonCustomPowershell\oh-my-posh\ys.omp.json" | Invoke-Expression
} else {
  Write-Host "Please install oh-my-posh from the Windows Store"
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
