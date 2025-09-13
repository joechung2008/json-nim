Write-Host "Cleaning build artifacts..."
Get-ChildItem -Recurse -Filter *.exe | Remove-Item -Force
Get-ChildItem -Recurse -Filter *.pdb | Remove-Item -Force
Get-ChildItem -Recurse -Filter *.ilk | Remove-Item -Force
Get-ChildItem -Recurse -Directory -Filter nimcache | Remove-Item -Recurse -Force
Write-Host "Clean completed!"