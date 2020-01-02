$targetPath = "master:\sitecore\content\home\MyNewItems"
$targetTemplate = "Service"
$items = Get-ChildItem -Path $targetPath -Recurse | Where-Object { $_.TemplateName -eq $targetTemplate }
if ($items)
{
    Write-Host "Removing $($items.Length) item(s) from '$($targetPath)' based on '$targetTemplate' data template"
    $items | Remove-Item
    Write-Host "Finished"
}