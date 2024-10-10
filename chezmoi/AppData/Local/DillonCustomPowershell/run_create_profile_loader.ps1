$loader_script = @"
. (Resolve-Path ~\AppData\Local\DillonCustomPowershell\profile.ps1).Path
"@;

if (Test-Path -Path $PROFILE) {
  $existing_profile = Get-Content -Path $PROFILE

  if ($loader_script -ne $existing_profile) {
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "!!Profile does not match!!"
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "Please check the contents of $PROFILE and delete or backup so this script can overwrite it."
  }
} else {
  Write-Host "Writing loader script to $PROFILE"
  $loader_script | Out-File -FilePath $PROFILE
}
