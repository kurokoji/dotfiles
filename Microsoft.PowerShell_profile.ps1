Set-PoshPrompt -Theme pure

Set-Item ENV:Path "$ENV:HOMEPATH\.cargo\bin;$ENV:Path"
Set-Item ENV:Path "$ENV:HOMEPATH\bin;$ENV:Path"

# Alias {{{

# if (Test-Path Alias:ls) {
#   Remove-Item Alias:ls
# }

Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open explorer.exe

# }}}

# Function {{{

function touch($file) {
  if (Test-Path $file) {
    (Get-Item $file).LastWriteTime = Get-Date
  }
  else {
    Out-File -encoding Default $file
  }
}

function which($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# }}}

Import-Module PSReadLine
Import-Module posh-git
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None

# PSfzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
$env:FZF_DEFAULT_OPTS="--height 40% --layout=reverse"
