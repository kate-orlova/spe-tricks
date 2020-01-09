$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try {
	$buckets | Remove-Item
}
finally {
	$bulk.Dispose()
	Write-Host "Finished"
}