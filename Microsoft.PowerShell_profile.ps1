# Set-PoshPrompt -Theme pure
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/emodipt-extend.omp.json" | Invoke-Expression

Set-Item ENV:Path "$ENV:HOMEPATH\.cargo\bin;$ENV:Path"
# Set-Item ENV:Path "~\.cargo\bin;$ENV:Path"
Set-Item ENV:Path "$ENV:HOMEPATH\bin;$ENV:Path"
# Set-Item ENV:Path "~\bin;$ENV:Path"

# Alias {{{

if (Test-Path Alias:ls) {
  Remove-Item Alias:ls
}

Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open explorer.exe
Set-Alias pbcopy clip.exe
Set-Alias unzip Expand-Archive

# }}}

# Function {{{

function ls($command) {
  exa --icons $command
}

function ll($command) {
  exa --icons -l  $command
}

function la($command) {
  exa --icons --all  $command
}

function lla($command) {
  exa --icons -l --all  $command
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
