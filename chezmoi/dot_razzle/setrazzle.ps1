if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  # This is set to 1 by my regular profile, then Razzle overrides the zoxide hook.
  # Set it to 0 to force it to actually reinitialize here
  $global:__zoxide_hooked = 0

  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
