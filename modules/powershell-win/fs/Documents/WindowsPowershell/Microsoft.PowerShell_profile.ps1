Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -EditMode Emacs

function global:prompt
{
    $hour = (Get-Date).Hour
    $minute = (Get-Date).Minute
    $second = (Get-Date).Second

    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    Write-Host -Object "[${hour}:${minute}:${second}] " -NoNewLine -ForegroundColor Red
    Write-Host -Object "${env:UserName}" -NoNewLine -ForegroundColor Green
    Write-Host -Object "@" -NoNewLine
    Write-Host -Object "${env:COMPUTERNAME}" -NoNewLine -ForegroundColor Blue
    Write-Host -Object " $($executionContext.SessionState.Path.CurrentLocation)" -ForegroundColor Yellow

    if ($IsAdmin) {
        return "# "
    } else {
        return "$ "
    }
}
