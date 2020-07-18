$init_files = Get-ChildItem -name -File .\etc\init\windows

foreach ($file in $init_files) {
  $path = ".\etc\init\windows\$file"
  Start-Process pwsh -ArgumentList @($path) -Wait
}

Write-Host "Complete!!" -ForegroundColor Red
Read-Host "Please press any key."
