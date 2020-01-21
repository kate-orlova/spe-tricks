$targetPath = "master:\sitecore\content\home\MyBucketItems"
$startTime = $(get-date)

$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try {
	$buckets = Get-ChildItem -Path $targetPath -Recurse | Where-Object { $_.TemplateName -eq "Bucket" }
	Write-Host "Deleteing $($buckets.Length) item(s) from '$($targetPath)'"
	
	$buckets | ForEach-Object {
        $bucketItems = Get-ChildItem -Path $_.ItemPath | Where-Object { $_.TemplateName -eq "Product" }
        $bucketItems | Remove-Item
		Write-Host "Bucket $($_.ItemPath) has been deleted"
	}
	
	$buckets | Remove-Item
}
finally {
	$bulk.Dispose()
	Write-Host "Finished"
	$currentTime = $(get-date)
	$elapsedTime = new-timespan $startTime $currentTime
	Write-Host "Elapsed time: $($elapsedTime.ToString("hh\:mm\:ss"))"
}