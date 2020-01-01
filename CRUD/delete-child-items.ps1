$targetPath = "master:\sitecore\content\home\MyNewItems"
$items = Get-ChildItem -Path $targetPath -Recurse
if ($items)
{
    Write-Host "Removing $($items.Length) item(s) from '$($targetPath)'"
    $items | Remove-Item
    Write-Host "Finished"
}