New-UsingBlock (New-Object Sitecore.Data.BulkUpdateContext) {
  Get-Item "master:\content\home\Unwanted item" | Remove-Item -Recurse -Permanently
}