$targetPath = "master:\sitecore\content\home\MyItems"
$itemTemplateId = "{xxx-yyy-zzz}"

$items = Get-ChildItem -Path $targetPath -Recurse | Where-Object { $_.TemplateID -eq $itemTemplateId }
if ($items) {
    Write-Host "Publishing $($items.Length) item(s) from '$($targetPath)'"
	
	$items | ForEach-Object {
        Publish-Item -Item $_ -recurse -verbose -publishmode Full -targets "web"
    }
	Write-Host "Finished"
}