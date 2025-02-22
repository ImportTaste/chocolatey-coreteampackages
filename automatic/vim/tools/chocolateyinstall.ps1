﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$shortversion = '81'
$pp = Get-PackageParameters

. $toolsDir\helpers.ps1
$installDir = Get-InstallDir

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $installDir
  file          = "$toolsDir\gvim_8.1.2237_x86.zip"
  file64        = "$toolsDir\gvim_8.1.2237_x64.zip"
}

$installArgs = @{
  statement = Get-Statement
  exeToRun  = "$installDir\vim\vim$shortversion\install.exe"
}

'$installDir', ($installDir | Out-String), '$packageArgs', ($packageArgs | Out-String), '$installArgs', ($installArgs | Out-String) | ForEach-Object { Write-Debug $_ }

Install-ChocolateyZipPackage @packageArgs
Start-ChocolateyProcessAsAdmin @installArgs
Copy-Item "$installDir\vim\vim$shortversion\vimtutor.bat" $env:windir
Set-Content -Path "$toolsDir\installDir" -Value $installDir
