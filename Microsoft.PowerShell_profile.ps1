Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Avit

# Alias {{{

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

# }}}
