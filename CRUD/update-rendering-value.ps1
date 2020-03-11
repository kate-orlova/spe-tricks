$sourcePath = "master:\sitecore\content\home\MyItems"
$itemTemplate = "Service"

$rendering = Get-Item "master:\sitecore\layout\Renderings\Modules\MyRendering"

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }
 
if ($items)
{
    Write-Host "'$($items.Length)' to be processed"
    $counter = 0
	
	$items | ForEach-Object {
		Write-Host "Processing item $counter"
		
		$itemRendering = $_ | Get-Rendering -Rendering $rendering -Placeholder "content-main" -Device (Get-LayoutDevice "Default")
		$itemRendering.Datasource = "YOUR_NEW_REF_ID"		
		
		$counter++
	}
	
	Write-Host "Finished"
}