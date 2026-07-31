if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  # Skip if zoxide's wrapper is installed already (avoid infinite recursion)
  if (${function:prompt} -notmatch '__zoxide_hook') {
    $global:__zoxide_hooked = 0

    Invoke-Expression (& { (zoxide init powershell | Out-String) })
  }
}
