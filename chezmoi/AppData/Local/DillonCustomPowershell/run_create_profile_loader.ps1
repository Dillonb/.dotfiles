$profile_path = (Resolve-Path ~\AppData\Local\DillonCustomPowershell\profile.ps1).Path

$loader_script = @"
. $profile_path
"@;

if (Test-Path -Path $PROFILE) {
  $existing_profile = Get-Content -Path $PROFILE

  if ($loader_script -eq $existing_profile) {
    Write-Host "No change needed to profile."
  } else {
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "!!Profile does not match!!"
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "Please check the contents of $PROFILE and delete or backup so this script can overwrite it."
  }
} else {
  Write-Host "Writing loader script to $PROFILE"
  $loader_script | Out-File -FilePath $PROFILE
}
