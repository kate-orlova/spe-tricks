Get-ChildItem -Path "master:/sitecore/content/{YourSite}" -Recurse |
  Where-Object { $_.Name -eq "Data" -and $_.Children.Count -eq 0 } |
  Remove-Item -Recurse -Force
