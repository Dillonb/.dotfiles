if (Get-Command oh-my-posh) {
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\ys.omp.json" | Invoke-Expression
} else {
  Write-Host "Please install oh-my-posh from the Windows Store"
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -EditMode Emacs
