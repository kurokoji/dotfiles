Set-PoshPrompt -Theme powerlevel10k_modern

Set-Item ENV:Path "$ENV:HOME\.cargo\bin;$ENV:Path"

Set-PSReadLineOption -PredictionSource History

# Alias {{{

Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open explorer.exe
Set-Alias ls exa

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
