$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try {
	$buckets | Remove-Item
}
finally {
}