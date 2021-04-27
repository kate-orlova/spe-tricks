$sourcePath = "master:\sitecore\content\home\MyItems"
$itemTemplate = "Service"
$newFieldValue = "New field value"

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }
 
if ($items)
{
    Write-Host "'$($items.Length)' to be processed"
    $counter = 0
	
	$items | ForEach-Object {
		Write-Host "Processing item $counter"
		$item = $_
		$item.Editing.BeginEdit()
		$item.Editing.EndEdit()
		
		$counter++
	}
	
	Write-Host "Finished"
}