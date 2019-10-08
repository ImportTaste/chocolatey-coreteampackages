﻿$ErrorActionPreference = 'Stop'
$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$pp = Get-PackageParameters

if ($pp.KeepExtensions) {
  return
}

$installLocation = Get-VirtualBoxIntallLocation
if (!$installLocation) { Write-Warning "Can not find existing installation location of $packageName"; return }
$vboxManage = "$installLocation\VBoxManage.exe"
if (!(Test-Path $vboxManage)) { Write-Warning "Existing installation of $packageName found but unable to find VBoxManage.exe"; return }

$extensions = . $vboxManage list extpacks | Where-Object { $_ -match 'Pack no' } | ForEach-Object { $_ -split '\:' | Select-Object -last 1 }

if ($extensions) {
  $extensions | ForEach-Object {
    $extName = $_.Trim()
    Write-Host "Uninstalling extension: '$extName'"
    Start-ChocolateyProcessAsAdmin -ExeToRun $vboxManage -Statements 'extpack','uninstall',"`"$extName`"" -Elevate 2>&1
  }

  Write-Host "Cleaning up extensions before uninstalling virtualbox"
  Start-ChocolateyProcessAsAdmin -ExeToRun $vboxManage -Statements 'extpack', 'cleanup' 2>&1
}
