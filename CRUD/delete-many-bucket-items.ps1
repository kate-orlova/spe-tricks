$targetPath = "master:\sitecore\content\home\MyBucketItems"
$startTime = $(get-date)

$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try {
	$buckets = Get-ChildItem -Path $targetPath -Recurse
	Write-Host "Deleteing $($buckets.Length) item(s) from '$($targetPath)'"
	$buckets | Remove-Item
}
finally {
	$bulk.Dispose()
	Write-Host "Finished"
}