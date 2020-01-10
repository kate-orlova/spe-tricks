$targetPath = "master:\sitecore\content\home\MyBucketItems"

$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try {
	$buckets = Get-ChildItem -Path $targetPath -Recurse
	$buckets | Remove-Item
}
finally {
	$bulk.Dispose()
	Write-Host "Finished"
}