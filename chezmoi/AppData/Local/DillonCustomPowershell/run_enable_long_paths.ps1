$ErrorActionPreference = "Stop"

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
if ((Get-ItemProperty -Path $registryPath).LongPathsEnabled -eq 1) {
  return
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Set-ItemProperty -Path $registryPath -Name "LongPathsEnabled" -Value 1 -Type DWord
  Write-Host "Windows long paths enabled. Restart affected applications or reboot for the change to take effect."
} else {
  Write-Host "Enabling Windows long paths requires administrator approval."
  $process = Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
    -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    throw "Failed to enable Windows long paths (exit code $($process.ExitCode))."
  }
}
