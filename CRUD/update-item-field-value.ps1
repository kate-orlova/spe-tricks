$sourcePath = "master:\sitecore\content\home\MyItems"
$itemTemplate = "Service"
$newFieldValue = "New field value"

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }
 
if ($items)
{
    Write-Host "'$($items.Length)' to be processed"
    $counter = 0

}