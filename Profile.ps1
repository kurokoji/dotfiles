# Set-PoshPrompt -Theme pure
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/amro.omp.json" | Invoke-Expression

Set-Item env:Path "$env:UserProfile\.cargo\bin;$env:Path"
# Set-Item ENV:Path "~\.cargo\bin;$ENV:Path"
Set-Item env:Path "$env:UserProfile\bin;$env:Path"
# Set-Item ENV:Path "~\bin;$ENV:Path"

# Alias {{{

if (Test-Path Alias:ls) {
  Remove-Item Alias:ls
}

Set-Alias lvim vim.exe
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open Invoke-Item
Set-Alias pbcopy clip.exe
Set-Alias unzip Expand-Archive

# }}}

# Function {{{

function ls($command) {
  eza --icons $command
}

function ll($command) {
  eza --icons -l  $command
}

function la($command) {
  eza --icons --all  $command
}

function lla($command) {
  eza --icons -l --all  $command
}

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

function pbc($file) {
  cat $file | clip
}

function rmrf($command) {
  Remove-Item -Recurse -Force $command
}

function scoop-update() {
  scoop update * --skip
  scoop cache rm --all
  scoop cleanup *
}

# }}}

Import-Module PSReadLine
Import-Module posh-git
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
# Tab押したら候補がMenu形式で出てくる
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# PSfzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
$env:FZF_DEFAULT_OPTS="--height 40% --layout=reverse"

(& volta completions powershell) | Out-String | Invoke-Expression
