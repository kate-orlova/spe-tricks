$sourcePath = "master:\sitecore\content\home\MyItems"
$itemTemplate = "Service"

$items = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.TemplateName -eq $itemTemplate }
 
if ($items)
{
}