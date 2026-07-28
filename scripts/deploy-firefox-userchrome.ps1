param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]
  $ProfilePath
)

$ErrorActionPreference = "Stop"

function Test-Admin {
  (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::
    GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Path -LiteralPath $ProfilePath -PathType Container)) {
  throw "Firefox profile directory does not exist: $ProfilePath"
}

$ProfilePath = (Resolve-Path -LiteralPath $ProfilePath).Path

# Symbolic links require administrator privileges unless Developer Mode is enabled.
if (!(Test-Admin)) {
  $arguments = @(
    "-NoProfile"
    "-File"
    "`"$PSCommandPath`""
    "-ProfilePath"
    "`"$ProfilePath`""
  )

  $process = Start-Process pwsh -ArgumentList $arguments -Verb RunAs -Wait -PassThru
  exit $process.ExitCode
}

$scriptPath = Convert-Path $PSCommandPath
$scriptDirectory = Split-Path -Parent $scriptPath
$dotDirectory = Split-Path -Parent $scriptDirectory
$sourcePath = Join-Path -Path $dotDirectory -ChildPath "userChrome.css"
$chromeDirectory = Join-Path -Path $ProfilePath -ChildPath "chrome"
$linkPath = Join-Path -Path $chromeDirectory -ChildPath "userChrome.css"

New-Item -ItemType Directory -Path $chromeDirectory -Force | Out-Null

$existingItem = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
if ($null -ne $existingItem) {
  if ($existingItem.LinkType -ne "SymbolicLink") {
    throw "Refusing to overwrite an existing file: $linkPath"
  }

  Remove-Item -LiteralPath $linkPath -Force
}

New-Item -ItemType SymbolicLink -Path $linkPath -Value $sourcePath | Out-Null

Write-Host "Complete!!" -ForegroundColor Red
