Set-PoshPrompt -Theme pure

Set-Item ENV:Path "$ENV:HOMEPATH\.cargo\bin;$ENV:Path"

Set-PSReadLineOption -PredictionSource History

# Alias {{{

Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open explorer.exe
Set-Alias ls "lsd"

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

# }}}

# PSfzf
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
# Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
# $env:FZF_DEFAULT_OPTS="--height 50% --layout=reverse"
