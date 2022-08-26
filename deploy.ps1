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


if (Test-Admin) {
  $EXCLUDE_FILES = @(
    "Brewfile", ".env.fish", ".git", ".gitignore", ".gitmodules",
    ".DS_Store", "README.md", "LICENSE", ".zshrc",
    "init.bash", "picture", "bin", "etc", "polybar", "tilix",
    "termite", "kitty", "fish", "i3", ".xinitrc", ".xprofile",
    ".Xresources", ".tmux.conf", "deploy.ps1", "deploy.bash", ".\Microsoft.PowerShell_profile.ps1",
    "userChrome.css"
  )

  $directories = Get-ChildItem -name -Directory $parent
  $files = Get-ChildItem -name -File $parent

  # ディレクトリのシンボリックリンク
  foreach ($dir in $directories) {
    if (-not ($EXCLUDE_FILES -contains $dir)) {
      $linkpath = (Join-Path -Resolve $parent $dir)
      New-Item -Type SymbolicLink -Path ~\.config -Name $dir -Value $linkpath
    }
  }

  # ファイルのシンボリックリンク
  foreach ($file in $files) {
    if (-not ($EXCLUDE_FILES -contains $file)) {
      $linkpath = (Join-Path -Resolve $parent $file)
      New-Item -Type SymbolicLink -Path ~ -Name $file -Value $linkpath
    }
  }

  $linkpath = (Join-Path -Resolve $parent "Microsoft.PowerShell_profile.ps1")

  $profilepath = (Split-Path -Parent $PROFILE)

  # PROFILEのシンボリックリンク
  New-Item -Force -Type SymbolicLink -Path $profilepath -Name "Microsoft.PowerShell_profile.ps1" -Value $linkpath

  Write-Host "Complete!!" -ForegroundColor Red
  Read-Host "Please press any key."
}
