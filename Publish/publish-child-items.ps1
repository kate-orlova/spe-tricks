$targetPath = "master:\sitecore\content\home\MyItems"

$items = Get-ChildItem -Path $targetPath -Recurse
if ($items) {
    Write-Host "Publishing $($items.Length) item(s) from '$($targetPath)'"
	
	$items | ForEach-Object {
        Publish-Item -Item $_ -recurse -verbose -publishmode Full -targets "web"
    }
	Write-Host "Finished"
}