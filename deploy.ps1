function Test-Admin {
  (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::
    GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Start-ScriptAsAdmin {
  param(
    [string]
    $ScriptPath,
    [object[]]
    $ArgumentList
  )

  if (!(Test-Admin)) {
    $list = @($ScriptPath)
    if ($null -ne $ArgumentList) {
      $list += @($ArgumentList)
    }
    # デフォルトのPowerShell
    # Start-Process powershell -ArgumentList $list -Verb RunAs -Wait

    # PowerShell Core
    Start-Process pwsh -ArgumentList $list -Verb RunAs -Wait
  }
}

# 管理者権限で再実行
Start-ScriptAsAdmin -ScriptPath $PSCommandPath

# dotfilesディレクトリの絶対パス取得
$path = (Convert-Path $PSCommandPath)
$parent = (Split-Path -Parent $path)
$configPath = (Join-Path -Path $parent -ChildPath "config")
$dotsPath = (Join-Path -Path $parent -ChildPath "dots")

Write-Host "${configPath}" -ForegroundColor Red
Write-Host "${dotsPath}" -ForegroundColor Red


if (Test-Admin) {
  $directories = Get-ChildItem -name -Directory $parent
  $configs = Get-ChildItem -name $configPath

  # ディレクトリのシンボリックリンク
  foreach ($dir in $configs) {
    $linkpath = (Join-Path -Resolve $configPath $dir)
    New-Item -Type SymbolicLink -Path ~\.config -Name $dir -Value $linkpath
    # alacrittyを%APPDATA%にリンクつくる
    if ($dir -eq "alacritty") {
      New-Item -Type SymbolicLink -Path $env:APPDATA -Name $dir -Value $linkpath
    }
  }

  $linkpath = (Join-Path -Resolve $parent "Profile.ps1")

  $profilepath = (Split-Path -Parent $PROFILE)

  # PROFILEのシンボリックリンク
  New-Item -Force -Type SymbolicLink -Path $profilepath -Name "Profile.ps1" -Value $linkpath

  Write-Host "Complete!!" -ForegroundColor Red
  Read-Host "Please press any key."
}
