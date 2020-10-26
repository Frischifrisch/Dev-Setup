chcp 65001

Import-Module posh-git
Import-Module oh-my-posh
Import-Module PSReadLine
Import-Module Get-ChildItemColor
Import-Module WindowsConsoleFonts
if (Test-Path -Path '~\Miniconda3\shell\condabin\conda-hook.ps1') {
    & '~\Miniconda3\shell\condabin\conda-hook.ps1'
}

Set-Theme AgnosterPlus
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function Complete

Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
Set-Alias ll Get-ChildItemColor -Option AllScope
Set-Alias which Get-Command -Option AllScope
Function rmrf($item) { Remove-Item -Path "$item" -Recurse -Force }
Function mkfile($file) { "" | Out-File -Path "$file" -Encoding utf8 }
Function Set-Proxy($proxyHost="127.0.0.1",
                   $httpPort=7890, $httpsPort=7890,
                   $ftpPort=7890, $socksPort=7891) {
    $Env:http_proxy="http://${proxyHost}:${httpPort}"
    $Env:https_proxy="http://${proxyHost}:${httpsPort}"
    $Env:ftp_proxy="http://${proxyHost}:${ftpPort}"
    $Env:all_proxy="socks5://${proxyHost}:${socksPort}"
    $Env:HTTP_PROXY="http://${proxyHost}:${httpPort}"
    $Env:HTTPS_PROXY="http://${proxyHost}:${httpsPort}"
    $Env:FTP_PROXY="http://${proxyHost}:${ftpPort}"
    $Env:ALL_PROXY="socks5://${proxyHost}:${socksPort}"
    [Environment]::SetEnvironmentVariable('http_proxy', "http://${proxyHost}:${httpPort}", 'Machine')
    [Environment]::SetEnvironmentVariable('https_proxy', "http://${proxyHost}:${httpsPort}", 'Machine')
    [Environment]::SetEnvironmentVariable('ftp_proxy', "http://${proxyHost}:${ftpPort}", 'Machine')
    [Environment]::SetEnvironmentVariable('all_proxy', "http://${proxyHost}:${socksPort}", 'Machine')

    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path "$regKey" -Name ProxyEnable -Value 1
    Set-ItemProperty -Path "$regKey" -Name ProxyServer -Value "${proxyHost}:${httpPort}"
}
Function Reset-Proxy() {
    Remove-Item -Path Env:\http_proxy -Force
    Remove-Item -Path Env:\https_proxy -Force
    Remove-Item -Path Env:\ftp_proxy -Force
    Remove-Item -Path Env:\all_proxy -Force
    Remove-Item -Path Env:\HTTP_PROXY -Force
    Remove-Item -Path Env:\HTTPS_PROXY -Force
    Remove-Item -Path Env:\FTP_PROXY -Force
    Remove-Item -Path Env:\ALL_PROXY -Force
    [Environment]::SetEnvironmentVariable('http_proxy', $null, 'Machine')
    [Environment]::SetEnvironmentVariable('https_proxy', $null, 'Machine')
    [Environment]::SetEnvironmentVariable('ftp_proxy', $null, 'Machine')
    [Environment]::SetEnvironmentVariable('all_proxy', $null, 'Machine')

    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path "$regKey" -Name ProxyEnable -Value 0
    Set-ItemProperty -Path "$regKey" -Name ProxyServer -Value ""
}